// #[test_only]
// module bookshop::bookshop_tests {
//     use bookshop::bookshop::{Self, ShopInfo, AdminCap, BookInfo, BookNFT};
//     use sui::test_scenario;
//     use sui::test_scenario::Scenario;
//     use sui::test_utils::assert_eq;
//     use sui::clock::{Self, Clock};
//     use std::string::{Self, String};
//     use sui::coin::{Self, Coin};
//     use sui::sui::SUI;
//     use sui::transfer;

//     #[test]
//     fun test_bookshop_init() {
//         let owner = @0x01;
//         let mut scenario_val: Scenario  = test_scenario::begin(owner);
//         let scenario = &mut scenario_val;

//         test_scenario::next_tx(scenario, owner);
//         {
//             bookshop::init_for_testing(test_scenario::ctx(scenario));
//         };

//         test_scenario::next_tx(scenario, owner);
//         {
//             let shopInfo = test_scenario::take_shared<ShopInfo>(scenario);
//             let pay_address = bookshop::GetShopInfoPayAddress(&shopInfo);
//             assert_eq(pay_address, owner);
//             test_scenario::return_shared(shopInfo);
//         };

//         test_scenario::end(scenario_val);
//     }

//     #[test]
//     fun test_bookinfo() {
//         let owner = @0x01;
//         let mut scenario_val: Scenario  = test_scenario::begin(owner);
//         let scenario = &mut scenario_val;

//         test_scenario::next_tx(scenario, owner);
//         {
//             bookshop::init_for_testing(test_scenario::ctx(scenario));
//         };

//         test_scenario::next_tx(scenario, owner);
//         {
//             let adminCap = test_scenario::take_from_address<AdminCap>(scenario, owner);
//             let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
//             clock::set_for_testing(&mut clock, 123);
//             bookshop::add_bookinfo(&adminCap, string::utf8(b"sui从入门到精通"), 12, 10, &clock, test_scenario::ctx(scenario));
//             test_scenario::return_to_address(owner, adminCap);
//             clock::destroy_for_testing(clock);
//         };

//         test_scenario::next_tx(scenario, owner);
//         {
//             let bookInfo = test_scenario::take_shared<BookInfo>(scenario);
//             let bookName = bookshop::GetBookInfoName(&bookInfo);
//             let bookPrice = bookshop::GetBookInfoPrice(&bookInfo);
//             let bookCount = bookshop::GetBookInfoCount(&bookInfo);
//             let bookCreateAt = bookshop::GetBookInfoCreateAt(&bookInfo);
//             let bookUpdateAt = bookshop::GetBookInfoUpdateAt(&bookInfo);

//             assert_eq(bookName, string::utf8(b"sui从入门到精通"));
//             assert_eq(bookPrice, 12);
//             assert_eq(bookCount, 10);
//             assert_eq(bookCreateAt, 123);
//             assert_eq(bookUpdateAt, 123);
//             test_scenario::return_shared(bookInfo);
//         };

//         test_scenario::next_tx(scenario, owner);
//         {
//             let adminCap = test_scenario::take_from_address<AdminCap>(scenario, owner);
//             let mut bookInfo = test_scenario::take_shared<BookInfo>(scenario);
//             let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
//             clock::set_for_testing(&mut clock, 125);
//             bookshop::update_bookinfo_name(&adminCap, &mut bookInfo, string::utf8(b"move从入门到放弃"), &clock, test_scenario::ctx(scenario));
//             bookshop::update_bookinfo_price(&adminCap, &mut bookInfo, 15, &clock, test_scenario::ctx(scenario));
//             bookshop::update_bookinfo_count(&adminCap, &mut bookInfo, 20, &clock, test_scenario::ctx(scenario));
//             bookshop::put_off_sale_bookinfo(&adminCap, &mut bookInfo, &clock, test_scenario::ctx(scenario));

//             test_scenario::return_to_address(owner, adminCap);
//             test_scenario::return_shared(bookInfo);
//             clock::destroy_for_testing(clock);
//         };

//         test_scenario::next_tx(scenario, owner);
//         {
//             let bookInfo = test_scenario::take_shared<BookInfo>(scenario);
//             let bookName = bookshop::GetBookInfoName(&bookInfo);
//             let bookPrice = bookshop::GetBookInfoPrice(&bookInfo);
//             let bookCount = bookshop::GetBookInfoCount(&bookInfo);
//             let bookUpdateAt = bookshop::GetBookInfoUpdateAt(&bookInfo);
//             let bookState = bookshop::GetBookInfoState(&bookInfo);
//             assert_eq(bookName, string::utf8(b"move从入门到放弃"));
//             assert_eq(bookPrice, 15);
//             assert_eq(bookCount, 20);
//             assert_eq(bookUpdateAt, 125);
//             assert_eq(bookState, 2);
//             test_scenario::return_shared(bookInfo);
//         };

//         test_scenario::end(scenario_val);
//     }

//     #[test]
//     fun test_buybook() {
//         let owner = @0x01245667;
//         let buyer = @0x02222222;
//         let mut scenario_val: Scenario  = test_scenario::begin(owner);
//         let scenario = &mut scenario_val;

//         test_scenario::next_tx(scenario, owner);
//         {
//             bookshop::init_for_testing(test_scenario::ctx(scenario));
//         };

//         test_scenario::next_tx(scenario, owner);
//         {
//             let adminCap = test_scenario::take_from_address<AdminCap>(scenario, owner);
//             let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
//             clock::set_for_testing(&mut clock, 123);
//             bookshop::add_bookinfo(&adminCap, string::utf8(b"sui从入门到精通"), 12, 10, &clock, test_scenario::ctx(scenario));
//             test_scenario::return_to_address(owner, adminCap);
//             clock::destroy_for_testing(clock);
//         };

//         test_scenario::next_tx(scenario, buyer);
//         {
//             let mut bookInfo = test_scenario::take_shared<BookInfo>(scenario);
//             let shopInfo = test_scenario::take_shared<ShopInfo>(scenario);
//             let pay_address = bookshop::GetShopInfoPayAddress(&shopInfo);
//             assert_eq(pay_address, owner);

//             let mut clock = clock::create_for_testing(test_scenario::ctx(scenario));
//             clock::set_for_testing(&mut clock, 128);

//             mint(buyer, 130, scenario);
//             let coin = test_scenario::take_from_sender<Coin<SUI>>(scenario);
//             bookshop::buy_book(&shopInfo, &mut bookInfo, coin, 5, &clock, test_scenario::ctx(scenario));

//             test_scenario::return_shared(bookInfo);
//             test_scenario::return_shared(shopInfo);
//             clock::destroy_for_testing(clock);
//         };

//         test_scenario::next_tx(scenario, buyer);
//         {
//             let mut bookInfo = test_scenario::take_shared<BookInfo>(scenario);

//             let remain_coin = test_scenario::take_from_sender<Coin<SUI>>(scenario);
//             let remain_value: u64 = coin::value(&remain_coin);
//             assert_eq(remain_value, 70);

//             let bookNFT =  test_scenario::take_from_address<BookNFT>(scenario, buyer);
//             let book_count = bookshop::GetBookNFTCount(&bookNFT);
//             assert_eq(book_count, 5);
//             let book_id = bookshop::GetBookNFTId(&bookNFT);
//             let bookinfo_id = bookshop::GetBookInfoId(&bookInfo);
//             assert_eq(book_id, bookinfo_id);

//             test_scenario::return_to_address(buyer, bookNFT);
//             test_scenario::return_to_sender(scenario, remain_coin);
//             test_scenario::return_shared(bookInfo);
//         };

//         test_scenario::next_tx(scenario, owner);
//         {
//             let owner_coin = test_scenario::take_from_sender<Coin<SUI>>(scenario);
//             let owner_coin_value: u64 = coin::value(&owner_coin);
//             assert_eq(owner_coin_value, 60);

//             test_scenario::return_to_sender(scenario, owner_coin);
//         };

//         test_scenario::end(scenario_val);
//     }

//     fun mint(addr: address, amount: u64, scenario: &mut Scenario) {
//         transfer::public_transfer(coin::mint_for_testing<SUI>(amount, test_scenario::ctx(scenario)), addr);
//         test_scenario::next_tx(scenario, addr);
//     }
// }

