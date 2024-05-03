#[test_only]
#[allow(unused_use)]
module bookshop::bookshop_tests {
    use bookshop::bookshop::{Self, Shop, Book, AdminCap};
    use sui::test_scenario::{Self, Scenario, ctx};
    use sui::test_utils::assert_eq;
    use sui::clock::{Self, Clock};
    use std::string::{Self, String};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    #[test]
    fun test_bookshop_init() {
        let owner = @0xa;
        let mut scenario_val = test_scenario::begin(owner);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, owner);
        {
            bookshop::init_for_testing(test_scenario::ctx(scenario));
        };

        test_scenario::next_tx(scenario, owner);
        {
            let shopInfo = test_scenario::take_shared<Shop>(scenario);
            let pay_address = bookshop::GetShopInfoPayAddress(&shopInfo);
            assert_eq(pay_address, owner);
            test_scenario::return_shared(shopInfo);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_bookinfo() {
        let owner = @0x01;
        let mut scenario_val  = test_scenario::begin(owner);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, owner);
        {
            bookshop::init_for_testing(test_scenario::ctx(scenario));
        };

        test_scenario::next_tx(scenario, owner);
        let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
        clock::set_for_testing(&mut clock, 123);
        let adminCap = test_scenario::take_from_address<AdminCap>(scenario, owner);
        let mut book = bookshop::new(&adminCap, string::utf8(b"sui从入门到精通"), 12, &clock, test_scenario::ctx(scenario));
        clock::destroy_for_testing(clock);      

        test_scenario::next_tx(scenario, owner);
        {
            let bookName = bookshop::GetBookName(&book);
            let bookPrice = bookshop::GetBookPrice(&book);
            let bookCreateAt = bookshop::GetBookCreateAt(&book);
            let bookUpdateAt = bookshop::GetBookUpdateAt(&book);

            assert_eq(bookName, string::utf8(b"sui从入门到精通"));
            assert_eq(bookPrice, 12);
            assert_eq(bookCreateAt, 123);
            assert_eq(bookUpdateAt, 123);
        };

        test_scenario::next_tx(scenario, owner);
        let mut shopInfo = test_scenario::take_shared<Shop>(scenario);
        let bookId = bookshop::GetBookId(&book);
        {

            let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
            clock::set_for_testing(&mut clock, 125);
            bookshop::new_name(&adminCap, &mut book, string::utf8(b"move从入门到放弃"), &clock, test_scenario::ctx(scenario));
            bookshop::new_price(&adminCap, &mut book, 15, &clock, test_scenario::ctx(scenario));
            clock::destroy_for_testing(clock);
        };

        test_scenario::next_tx(scenario, owner);
        {
            let bookName = bookshop::GetBookName(&book);
            let bookPrice = bookshop::GetBookPrice(&book);
            let bookUpdateAt = bookshop::GetBookUpdateAt(&book);
            assert_eq(bookName, string::utf8(b"move从入门到放弃"));
            assert_eq(bookPrice, 15);
            assert_eq(bookUpdateAt, 125);
            bookshop::list(&adminCap, &mut shopInfo, book);
            let book = bookshop::delist(&adminCap, &mut shopInfo, bookId);
            transfer::public_transfer(book, owner);
        };

        test_scenario::return_shared(shopInfo);
        test_scenario::return_to_address(owner, adminCap);
        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_buybook() {
        let owner = @0xa;
        let buyer = @0xb;
        let mut scenario_val  = test_scenario::begin(owner);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, owner);
        {
            bookshop::init_for_testing(test_scenario::ctx(scenario));
        };

        test_scenario::next_tx(scenario, owner);
        
        let adminCap = test_scenario::take_from_address<AdminCap>(scenario, owner);
        let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
        clock::set_for_testing(&mut clock, 123);
        let book = bookshop::new(&adminCap, string::utf8(b"sui从入门到精通"), 10, &clock, test_scenario::ctx(scenario));
        clock::destroy_for_testing(clock);
        

        test_scenario::next_tx(scenario, buyer);
        let mut shopInfo = test_scenario::take_shared<Shop>(scenario);
        let bookId = bookshop::GetBookId(&book);
        {
            bookshop::list(&adminCap, &mut shopInfo, book);
            let pay_address = bookshop::GetShopInfoPayAddress(&shopInfo);
            assert_eq(pay_address, owner);

            let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
            clock::set_for_testing(&mut clock, 128);

            mint(buyer, 30, scenario);
            let mut coin = test_scenario::take_from_sender<Coin<SUI>>(scenario);
            bookshop::purchase(&mut shopInfo, bookId, &mut coin, test_scenario::ctx(scenario));
            test_scenario::return_to_sender(scenario, coin);
            clock::destroy_for_testing(clock);
        };

        test_scenario::next_tx(scenario, buyer);
        {
            let remain_coin = test_scenario::take_from_sender<Coin<SUI>>(scenario);
            let remain_value: u64 = coin::value(&remain_coin);
            assert_eq(remain_value, 20);
            test_scenario::return_to_sender(scenario, remain_coin);
        };

        test_scenario::next_tx(scenario, owner);
        
        {bookshop::withdraw_profits(&adminCap, &mut shopInfo, 10, test_scenario::ctx(scenario));};

        test_scenario::next_tx(scenario, owner);
        {
            let owner_coin = test_scenario::take_from_sender<Coin<SUI>>(scenario);
            let owner_coin_value: u64 = coin::value(&owner_coin);
            assert_eq(owner_coin_value, 10);
            test_scenario::return_to_sender(scenario, owner_coin);
        };

        test_scenario::return_to_address(owner, adminCap);
        test_scenario::return_shared(shopInfo);
        test_scenario::end(scenario_val);
    }

    #[test, expected_failure(abort_code = 0)]
    fun test_buybook_failure_insufficient_fund() {
        let owner = @0xa;
        let buyer = @0xb;
        let mut scenario_val  = test_scenario::begin(owner);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, owner);
        {
            bookshop::init_for_testing(test_scenario::ctx(scenario));
        };

        test_scenario::next_tx(scenario, owner);
        
        let adminCap = test_scenario::take_from_address<AdminCap>(scenario, owner);
        let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
        clock::set_for_testing(&mut clock, 123);
        let book = bookshop::new(&adminCap, string::utf8(b"sui从入门到精通"), 40, &clock, test_scenario::ctx(scenario));
        clock::destroy_for_testing(clock);
        

        test_scenario::next_tx(scenario, buyer);
        let mut shopInfo = test_scenario::take_shared<Shop>(scenario);
        let bookId = bookshop::GetBookId(&book);
        {
            bookshop::list(&adminCap, &mut shopInfo, book);
            mint(buyer, 30, scenario);
            let mut coin = test_scenario::take_from_sender<Coin<SUI>>(scenario);
            bookshop::purchase(&mut shopInfo, bookId, &mut coin, test_scenario::ctx(scenario));
            test_scenario::return_to_sender(scenario, coin);
        };
        test_scenario::return_to_address(owner, adminCap);
        test_scenario::return_shared(shopInfo);
        test_scenario::end(scenario_val);
    }

        #[test, expected_failure(abort_code = 2)]
    fun test_buybook_failure_book_unavailable() {
        let owner = @0xa;
        let buyer = @0xb;
        let mut scenario_val  = test_scenario::begin(owner);
        let scenario = &mut scenario_val;

        test_scenario::next_tx(scenario, owner);
        {
            bookshop::init_for_testing(test_scenario::ctx(scenario));
        };

        test_scenario::next_tx(scenario, owner);
        
        let adminCap = test_scenario::take_from_address<AdminCap>(scenario, owner);
        let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
        clock::set_for_testing(&mut clock, 123);
        let book = bookshop::new(&adminCap, string::utf8(b"sui从入门到精通"), 40, &clock, test_scenario::ctx(scenario));
        clock::destroy_for_testing(clock);
        

        test_scenario::next_tx(scenario, buyer);
        let mut shopInfo = test_scenario::take_shared<Shop>(scenario);
        let bookId = bookshop::GetBookId(&book);
        {
            mint(buyer, 30, scenario);
            let mut coin = test_scenario::take_from_sender<Coin<SUI>>(scenario);
            bookshop::purchase(&mut shopInfo, bookId, &mut coin, test_scenario::ctx(scenario));
            test_scenario::return_to_sender(scenario, coin);
        };
        transfer::public_transfer(book, owner);
        test_scenario::return_to_address(owner, adminCap);
        test_scenario::return_shared(shopInfo);
        test_scenario::end(scenario_val);
    }

    fun mint(addr: address, amount: u64, scenario: &mut Scenario) {
        transfer::public_transfer(coin::mint_for_testing<SUI>(amount, test_scenario::ctx(scenario)), addr);
        test_scenario::next_tx(scenario, addr);
    }
}

