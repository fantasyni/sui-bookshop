/// Module: bookshop
module bookshop::bookshop {
   //==============================================================================================
   //                                  Dependencies
   //==============================================================================================
   use sui::object::{Self, UID, ID};
   use sui::transfer;
   use sui::tx_context::{Self, TxContext};
   use sui::coin::{Self, Coin};
   use sui::balance::{Self, Balance};
   use sui::sui::SUI;
   use sui::clock::{Self, Clock};
   use std::string::{Self, String};
   use sui::event;

   //==============================================================================================
   //                                  Constants
   //==============================================================================================
   const BOOK_STATE_ON_SALE: u8 = 1;
   const BOOK_STATE_OFF_SALE: u8 = 2;

   //==============================================================================================
   //                                  Error codes
   //==============================================================================================
   const EBookNameInvalid: u64 = 1;
   const EBuyBookSuiNotEnough: u64 = 2;
   const EBookNotOnSale: u64 = 3;
   const EBookAmountNotEnough: u64 = 4;
   const EBookBuyAmountInvalid: u64 = 5;
   const EBookBuySuiAmountInvalid: u64 = 6;
   const EBookNameNotChanged: u64 = 7;
   const EBookPriceNotChanged: u64 = 8;
   const EBookCountNotChanged: u64 = 9;
   const EBookStateNotChanged: u64 = 10;

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

   /*
       ShopInfo manages the shop informations, now contains the payment address for consumers
       - id: the unique id of the ShopInfo
       - pay_adderss: payment address
   */
   public struct ShopInfo has key {
       id: UID,
       pay_address: address,
   }

   /*
       BookInfo contains the book information
       - id: the unique id of the book
       - name: book name
       - price: book price
       - count: book remain counts
       - create_at: book info created timestamp
       - update_at: book info updated timestamp
       - state: book state for on-sale (BOOK_STATE_ON_SALE) or off-sale (BOOK_STATE_OFF_SALE)
   */
   public struct BookInfo has key {
       id: UID,
       name: String,
       price: u64,
       count: u64,
       create_at: u64,
       update_at: u64,
       state: u8,
   }

   /*
       BookNFT for consumers when they bought books
       - id: the unique id of the BookNFT
       - book_id: the unique id of the BookInfo
       - book_count: the count of books
       - create_at: book nft created timestamp
   */
   public struct BookNFT has key {
       id: UID,
       book_id: ID,
       book_count: u64,
       create_at: u64,
   }

   //==============================================================================================
   //                                  Event structs
   //==============================================================================================
   /*
       Event emitted when add book event happened.
           - book_id: the id of the bookinfo.
           - name: book name.
           - price: book price.
           - count: book count
           - state: book state for on-sale (BOOK_STATE_ON_SALE) or off-sale (BOOK_STATE_OFF_SALE)
   */
   public struct AddBookEvent has copy, drop {
       book_id: ID,
       name: String,
       price: u64,
       count: u64,
       state: u8,
   }

   /*
       Event emitted when update book name event happened.
           - book_id: the id of the bookinfo.
           - oldname: book old name.
           - name: book name.
   */
   public struct UpdateBookNameEvent has copy, drop {
       book_id: ID,
       oldname: String,
       name: String,
   }

   /*
       Event emitted when update book price event happened.
           - book_id: the id of the bookinfo.
           - oldprice: book old price.
           - price: book price.
   */
   public struct UpdateBookPriceEvent has copy, drop {
       book_id: ID,
       oldprice: u64,
       price: u64,
   }

   /*
       Event emitted when update book count event happened.
           - book_id: the id of the bookinfo.
           - oldcount: book old count.
           - count: book count.
   */
   public struct UpdateBookCountEvent has copy, drop {
       book_id: ID,
       oldcount: u64,
       count: u64,
   }

   /*
       Event emitted when update book state event happened.
           - book_id: the id of the bookinfo.
           - oldstate: book old state.
           - state: book state.
   */
   public struct UpdateBookStateEvent has copy, drop {
       book_id: ID,
       oldstate: u8,
       state: u8,
   }

   /*
       Event emitted when buy book event happened.
           - book_id: the id of the bookinfo.
           - book_count: buy book amount.
           - create_at: buy book timestamp.
   */
   public struct BuyBookEvent has copy, drop {
       book_id: ID,
       book_count: u64,
       create_at: u64,
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

       let shopInfo = ShopInfo {
           id: object::new(ctx),
           pay_address: admin_address
       };
       transfer::share_object(shopInfo);
   }

   /*
       add book to the bookshop, it will make BookInfo share object, and emit AddBookEvent event
       @param adminCap: the admin role capability controll
       @param name: book name
       @param price: book price
       @param count: book count
       @param clock: clock for timestamp
       @param ctx: The transaction context.
   */
   public fun add_bookinfo(adminCap: &AdminCap, name: String, price: u64, count: u64, clock: &Clock, ctx: &mut TxContext) {
       assert!(!string::is_empty(&name), EBookNameInvalid);
       assert!(price > 0, "Book price must be greater than 0");
       assert!(count > 0, "Book count must be greater than 0");
       let uid = object::new(ctx);
       let id = object::uid_to_inner(&uid);

       transfer::share_object(BookInfo{
           id: uid,
           name: name,
           price: price,
           count: count,
           state: BOOK_STATE_ON_SALE,
           create_at: clock::timestamp_ms(clock),
           update_at: clock::timestamp_ms(clock)
       });

       event::emit(AddBookEvent{
           book_id : id,
           name: name,
           price: price,
           count: count,
           state: BOOK_STATE_ON_SALE
       });
   }

   /*
       update book name, it will emit AddBookEvent event
       @param adminCap: the admin role capability controll
       @param bookinfo: bookinfo struct
       @param name: book name
       @param clock: clock for timestamp
       @param ctx: The transaction context.
   */
   public fun update_bookinfo_name(adminCap: &AdminCap, bookinfo: &mut BookInfo, name: String, clock: &Clock, _ctx: &mut TxContext) {
       assert!(!string::is_empty(&name), EBookNameInvalid);
       assert!(bookinfo.name != name, EBookNameNotChanged);

       event::emit(UpdateBookNameEvent{
           book_id : object::uid_to_inner(&bookinfo.id),
           oldname: bookinfo.name,
           name: name,
       });

       bookinfo.name = name;
       bookinfo.update_at = clock::timestamp_ms(clock);
   }

   /*
       update book price, it will emit UpdateBookPriceEvent event
       @param adminCap: the admin role capability controll
       @param bookinfo: bookinfo struct
       @param price: book price
       @param clock: clock for timestamp
       @param ctx: The transaction context.
   */
   public fun update_bookinfo_price(adminCap: &AdminCap, bookinfo: &mut BookInfo, price: u64, clock: &Clock, _ctx: &mut TxContext) {
       assert!(price > 0, "Book price must be greater than 0");
       assert!(bookinfo.price != price, EBookPriceNotChanged);

       event::emit(UpdateBookPriceEvent{
           book_id : object::uid_to_inner(&bookinfo.id),
           oldprice: bookinfo.price,
           price: price,
       });

       bookinfo.price = price;
       bookinfo.update_at = clock::timestamp_ms(clock);
   }

   /*
       update book count, it will emit UpdateBookCountEvent event
       @param adminCap: the admin role capability controll
       @param bookinfo: bookinfo struct
       @param count: book count
       @param clock: clock for timestamp
       @param ctx: The transaction context.
   */
   public fun update_bookinfo_count(adminCap: &AdminCap, bookinfo: &mut BookInfo, count: u64, clock: &Clock, _ctx: &mut TxContext) {
       assert!(count > 0, "Book count must be greater than 0");
       assert!(bookinfo.count != count, EBookCountNotChanged);

       event::emit(UpdateBookCountEvent{
           book_id : object::uid_to_inner(&bookinfo.id),
           oldcount: bookinfo.count,
           count: count,
       });

       bookinfo.count = count;
       bookinfo.update_at = clock::timestamp_ms(clock);
   }

   /*
       update book state on sale, it will emit UpdateBookStateEvent event
       @param adminCap: the admin role capability controll
       @param bookinfo: bookinfo struct
       @param clock: clock for timestamp
       @param ctx: The transaction context.
   */
   public fun put_on_sale_bookinfo(adminCap: &AdminCap, bookinfo: &mut BookInfo, clock: &Clock, _ctx: &mut TxContext) {
       assert!(bookinfo.state != BOOK_STATE_ON_SALE, EBookStateNotChanged);

       event::emit(UpdateBookStateEvent{
           book_id : object::uid_to_inner(&bookinfo.id),
           oldstate: bookinfo.state,
           state: BOOK_STATE_ON_SALE,
       });
       bookinfo.state = BOOK_STATE_ON_SALE;
       bookinfo.update_at = clock::timestamp_ms(clock);
   }

   /*
       update book state off sale, it will emit UpdateBookStateEvent event
       @param adminCap: the admin role capability controll
       @param bookinfo: bookinfo struct
       @param clock: clock for timestamp
       @param ctx: The transaction context.
   */
   public fun put_off_sale_bookinfo(adminCap: &AdminCap, bookinfo: &mut BookInfo, clock: &Clock, _ctx: &mut TxContext) {
       assert!(bookinfo.state != BOOK_STATE_OFF_SALE, EBookStateNotChanged);

       event::emit(UpdateBookStateEvent{
           book_id : object::uid_to_inner(&bookinfo.id),
           oldstate: bookinfo.state,
           state: BOOK_STATE_OFF_SALE,
       });
       bookinfo.state = BOOK_STATE_OFF_SALE;
       bookinfo.update_at = clock::timestamp_ms(clock);
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
   public fun buy_book(shopInfo: &ShopInfo, bookinfo: &mut BookInfo, sui: Coin<SUI>, amount: u64, clock: &Clock, ctx: &mut TxContext) {
       assert!(bookinfo.state == BOOK_STATE_ON_SALE, EBookNotOnSale);
       assert!(amount > 0, EBookBuyAmountInvalid);
       assert!(bookinfo.count >= amount, EBookAmountNotEnough);

       let sui_amount: u64 = coin::value<SUI>(&sui);
       assert!(sui_amount > 0, EBookBuySuiAmountInvalid);

       let need_pay: u64 = bookinfo.price * amount;
       let time_stamp: u64 = clock::timestamp_ms(clock);
       assert!(need_pay <= sui_amount, EBuyBookSuiNotEnough);
       let sender_address: address = tx_context::sender(ctx);

       bookinfo.count = bookinfo.count - amount;
       let mut sui_balance = coin::into_balance(sui);

       if (sui_amount > need_pay) {
           let left_balance = balance::split(&mut sui_balance, sui_amount - need_pay);
           transfer::public_transfer(coin::from_balance(left_balance, ctx), sender_address);
       };

       transfer::public_transfer(coin::from_balance(sui_balance, ctx), shopInfo.pay_address);

       let bookNFT = BookNFT {
           id: object::new(ctx),
           book_id: object::uid_to_inner(&bookinfo.id),
           book_count: amount,
           create_at: time_stamp
       };
       transfer::transfer(bookNFT, sender_address);

       event::emit(BuyBookEvent{
           book_id : object::uid_to_inner(&bookinfo.id),
           book_count: amount,
           create_at: time_stamp
       });
   }

   /*
       get book id
       @param bookinfo: bookinfo struct
       @return : book ID.
   */
   public fun GetBookInfoId(bookInfo: &BookInfo): ID {
       object::uid_to_inner(&bookInfo.id)
   }

   /*
       get book name
       @param bookinfo: bookinfo struct
       @return : book name.
   */
   public fun GetBookInfoName(bookInfo: &BookInfo): String {
       bookInfo.name
   }

   /*
       get book price
       @param bookinfo: bookinfo struct
       @return : book price.
   */
   public fun GetBookInfoPrice(bookInfo: &BookInfo): u64 {
       bookInfo.price
   }

   /*
       get book count
       @param bookinfo: bookinfo struct
       @return : book count.
   */
   public fun GetBookInfoCount(bookInfo: &BookInfo): u64 {
       bookInfo.count
   }

   /*
       get book created timestamp
       @param bookinfo: bookinfo struct
       @return : created timestamp.
   */
   public fun GetBookInfoCreateAt(bookInfo: &BookInfo): u64 {
       bookInfo.create_at
   }

   /*
       get book update timestamp
       @param bookinfo: bookinfo struct
       @return : update timestamp.
   */
   public fun GetBookInfoUpdateAt(bookInfo: &BookInfo): u64 {
       bookInfo.update_at
   }

/*
        get book state for on-sale (BOOK_STATE_ON_SALE) or off-sale (BOOK_STATE_OFF_SALE)
        @param bookinfo: bookinfo struct
        @return : book state.
    */
    public fun GetBookInfoState(bookInfo: &BookInfo): u8 {
        bookInfo.state
    }

    /*
        get shop payment address
        @param shopInfo: ShopInfo struct
        @return : payment address.
    */
    public fun GetShopInfoPayAddress(shopInfo: &ShopInfo): address {
        shopInfo.pay_address
    }

    /*
        get book nft count
        @param bookNFT: BookNFT struct
        @return : book nft count.
    */
    public fun GetBookNFTCount(bookNFT: &BookNFT): u64 {
        bookNFT.book_count
    }

    /*
        get book nft id
        @param bookNFT: BookNFT struct
        @return : book nft id.
    */
    public fun GetBookNFTId(bookNFT: &BookNFT): ID {
        bookNFT.book_id
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(BOOKSHOP {}, ctx);
    }
}
