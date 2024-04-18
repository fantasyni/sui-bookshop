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
    use sui::dynamic_field as df;

    //==============================================================================================
    //                                  Error codes
    //==============================================================================================

    const EBookBuyAmountInvalid: u64 = 0;
    const EBookPriceNotChanged: u64 = 1;

    //==============================================================================================
    //                                  Module structs
    //==============================================================================================

    /*
        AdminCap is the capability for admin role management
    */
    public struct AdminCap has key {
        id: UID,
    }

    /*
        BOOKSHOP is the one time witness for module init
    */
    public struct BOOKSHOP has drop {
    }

    public struct Item has store, copy, drop { id: ID }

    public struct Listing has store, copy, drop { id: ID, is_exclusive: bool }

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
        - book_count: the count of books
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
    fun init(_otw: BOOKSHOP, ctx: &mut TxContext) {
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
    public fun new_name(self: &mut Book, name: String, clock: &Clock) {
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
    public fun new_price(self: &mut Book, price: u64, clock: &Clock, _ctx: &mut TxContext) {
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
    public fun list(_: &AdminCap, self: &mut Shop, book: Book, price: u64) {
        let id_ = book.inner;
        place_internal(self, book);

        df::add(&mut self.id, Listing { id: id_, is_exclusive: false }, price);
    }

    /*
        update book state off sale, it will emit UpdateBookStateEvent event
        @param adminCap: the admin role capability controll
        @param bookinfo: bookinfo struct
        @param clock: clock for timestamp
        @param ctx: The transaction context.
    */
    public fun delist(_: &AdminCap, self: &mut Shop, id: ID) {
        df::remove<Listing, u64>(&mut self.id, Listing { id, is_exclusive: false });
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
    public fun purchase(self: &mut Shop, id: ID, payment: Coin<SUI>) : Book {
        let price = df::remove<Listing, u64>(&mut self.id, Listing { id, is_exclusive: false });
        let item = dof::remove<Item, Book>(&mut self.id, Item { id });

        self.item_count = self.item_count - 1;
        assert!(price == payment.value(), EBookBuyAmountInvalid);
        coin::put(&mut self.balance, payment);

        item
    }

    public fun withdraw_profits(_: &AdminCap, self: &mut Shop, amount: u64, ctx: &mut TxContext) : Coin<SUI> {
        coin::take(&mut self.balance, amount, ctx)
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
        get book nft count
        @param Book: Book struct
        @return : book nft count.
    */
    public fun GetBookCount(self: &Book): u64 {
        self.price
    }

    /*
        get book nft id
        @param Book: Book struct
        @return : book nft id.
    */
    public fun GetBookId(self: &Book): ID {
        self.inner
    }

    fun place_internal(self: &mut Shop, book: Book) {
        self.item_count = self.item_count + 1;
        dof::add(&mut self.id, Item { id: object::id(&book) }, book)
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(BOOKSHOP {}, ctx);
    }
}

