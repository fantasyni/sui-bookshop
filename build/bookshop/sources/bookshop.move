/// Module: bookshop
module bookshop::bookshop {
    //==============================================================================================
    //                                  Dependencies
    //==============================================================================================
    use sui::tx_context::{sender};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use sui::clock::{Self, Clock, timestamp_ms};
    use std::string::{String};
    use sui::dynamic_object_field as dof;

    //==============================================================================================
    //                                  Error codes
    //==============================================================================================

    const EInsufficientPayment: u64 = 0;
    const EBookPriceNotChanged: u64 = 1;
    const EItemNotAvailable: u64 = 2;

    //==============================================================================================
    //                                  Module structs
    //==============================================================================================

    /*
        AdminCap is the capability for admin role management
    */
    public struct AdminCap has key {
        id: UID,
    }

    public struct Listing has store, copy, drop { id: ID}

    /*
        ShopInfo manages the shop informations, now contains the payment address for consumers
        - id: the unique id of the ShopInfo
        - pay_adderss: payment address
    */
    public struct Shop has key {
        id: UID,
        owner: address,
        item_count: u64,
        balance: Balance<SUI>
    }

    /*
        Book for consumers when they bought books
        - id: the unique id of the Book
        - book_id: the unique id of the BookInfo
        - create_at: book nft created timestamp
    */
    public struct Book has key, store {
        id: UID,
        inner: ID,
        name: String,
        price: u64,
        create_at: u64,
        update_at: u64,
    }

    //==============================================================================================
    //                                      Functions
    //==============================================================================================
    /*
        init function for module init
        transfer AdminCap to the admin
        make ShopInfo share object
    */
    fun init(ctx: &mut TxContext) {
        let admin_address = tx_context::sender(ctx);
        let admin_cap = AdminCap {
            id: object::new(ctx)
        };
        transfer::transfer(admin_cap, admin_address);

        let shop = Shop {
            id: object::new(ctx),
            owner: sender(ctx),
            item_count:0,
            balance: balance::zero()
        };
        transfer::share_object(shop);
    }

    public fun new(
        _: &AdminCap,
        name_: String,
        price: u64,
        c: &Clock,
        ctx: &mut TxContext
    ) : Book {
        let id_ = object::new(ctx);
        let inner_ = object::uid_to_inner(&id_);

        let book = Book {
            id: id_,
            inner: inner_,
            name: name_,
            price: price,
            create_at: timestamp_ms(c),
            update_at: timestamp_ms(c)
        };
        book
    }

    /*
        update book name, it will emit AddBookEvent event
        @param adminCap: the admin role capability controll
        @param name: book name
        @param clock: clock for timestamp
        @param ctx: The transaction context.
    */
    public fun new_name(_: &AdminCap, self: &mut Book, name: String, clock: &Clock, _ctx: &mut TxContext) {
        self.name = name;
        self.update_at = timestamp_ms(clock);
    }

    /*
        update book price, it will emit UpdateBookPriceEvent event
        @param adminCap: the admin role capability controll
        @param bookinfo: bookinfo struct
        @param price: book price
        @param clock: clock for timestamp
        @param ctx: The transaction context.
    */
    public fun new_price(_: &AdminCap, self: &mut Book, price: u64, clock: &Clock, _ctx: &mut TxContext) {
        assert!(self.price != price, EBookPriceNotChanged);
        self.price = price;
        self.update_at = clock::timestamp_ms(clock);
    }

    // /*
    //     update book state on sale, it will emit UpdateBookStateEvent event
    //     @param adminCap: the admin role capability controll
    //     @param bookinfo: bookinfo struct
    //     @param clock: clock for timestamp
    //     @param ctx: The transaction context.
    // */
    public fun list(_: &AdminCap, self: &mut Shop, book: Book) {
        let id_ = book.inner;
        self.item_count = self.item_count + 1;
        //dof: [object, name, value]: [shop_id, Listing(which is book_id), book]
        dof::add(&mut self.id, Listing { id: id_}, book)
    }

    /*
        update book state off sale, it will emit UpdateBookStateEvent event
        @param adminCap: the admin role capability controll
        @param bookinfo: bookinfo struct
        @param clock: clock for timestamp
        @param ctx: The transaction context.
    */
    public fun delist(_: &AdminCap, self: &mut Shop, id: ID): Book {
        dof::remove<Listing, Book>(&mut self.id, Listing { id })
    }

    /*
        buy book function, it will emit BuyBookEvent event
        @param shopInfo: ShopInfo struct
        @param bookinfo: bookinfo struct
        @param sui: sui payed to buy book
        @param amount: buy book amount
        @param clock: clock for timestamp
        @param ctx: The transaction context.
    */
    #[allow(lint(self_transfer))]
    public fun purchase(self: &mut Shop, id: ID, payment: &mut Coin<SUI>, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(dof::exists_(&self.id, Listing { id }), EItemNotAvailable);
        let book = dof::remove<Listing, Book>(&mut self.id, Listing { id });
        self.item_count = self.item_count - 1;
        assert!(book.price <= payment.value(), EInsufficientPayment);
        let payment_coin = coin::split(payment, book.price, ctx);
        coin::put(&mut self.balance, payment_coin);
        transfer::public_transfer(book, sender);
    }

    public fun withdraw_profits(_: &AdminCap, self: &mut Shop, amount: u64, ctx: &mut TxContext){
        let sender = tx_context::sender(ctx);
        transfer::public_transfer(coin::take(&mut self.balance, amount, ctx), sender);
    }

    /*
        get shop payment address
        @param shopInfo: ShopInfo struct
        @return : payment address.
    */
    public fun GetShopInfoPayAddress(self: &Shop): address {
        self.owner
    }

    /*
        get book nft id
        @param Book: Book struct
        @return : book nft id.
    */
    public fun GetBookId(self: &Book): ID {
        self.inner
    }

    public fun GetBookName(self: &Book): String {
        self.name
    }

    public fun GetBookPrice(self: &Book): u64 {
        self.price
    }

    public fun GetBookCreateAt(self: &Book): u64 {
        self.create_at
    }

    public fun GetBookUpdateAt(self: &Book): u64 {
        self.update_at
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(ctx);
    }
}

