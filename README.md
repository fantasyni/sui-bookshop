# sui bookshop - huisq feedback
This is the feedback for sui bookshop on dacade by huisq

## bookshop.move:
1. Removed BookShop struct and its use in init because it's unnecessary.
2. Subsequently edited function init_for_testing to be used in bookshop_tests.move
3. Is_exclusive arg in Listing is not used, deleted.
4. Refractor EBookBuyAmountInvalid to EInsufficientPayment to make more sense
5. place_internal and listing are redundant. Deleted place_internal to streamline the code
6. Item and Listing are redundant. Deleted Item to streamline the code
7. Deleted price arg in list function as it is already saved in Book struct
8. Subsequently strealined purchase function
9. Added assert check to make sure item to purchase is available
10. Missing function GetBookName, GetBookPrice, GetBookCreateAt, GetBookUpdateAt which are used in bookshop_tests.move. Added in bookshop.move
11. new_name and new_price function require AdminCap
12. After book is purchased, the book should be transferred to the buyer
13. In purchase function, payment should be mutable to refund excess payment
14. In withdraw profits function, send the coin to the sender directly, which is the shop owner

## bookshop_tests.move:
1. There is no BookInfo, ShopInfo, BookNFT struct in bookshop.move, thus, removed from bookshop_tests.move
2. Added Book and Shop Struct declaration in bookshop_tests.move instead
3. Multiple wrong bookshop.move function names used in bookshop_tests.move, refractored
4. Function update_bookinfo_count is invalid as each book only has 1 count based on Book Struct in bookshop.move which did not has count in its Struct arg and from purchase function it can be seen that it will be delisted the minute it's bought. 
5. Function GetBookInfoState and GetBookNFTCount in bookshop_tests.move are invalid. Removed.
6. Added expected_fail test cases: insufficient payment, book to purchase not available
