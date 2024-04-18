# sui bookshop
this is an implementaion of bookshop through MOVE contract in sui blockchain.        
There are two roles in the bookshop, ``Admin`` and ``Consumer``  
``Admin`` manage the books, actions like add_bookinfo, update_bookinfo_name etc.  
``Consumer`` can buy book through ``buy_book`` move function.

## FUNCTION

### add_bookinfo
admin can add book info the bookshop

### update_bookinfo_name
admin can update book name

### update_bookinfo_price
admin can update book price

### update_bookinfo_count
admin can update book remain counts

### put_on_sale_bookinfo
admin can update book state of on-sale

### put_off_sale_bookinfo
admin can update book state of off-sale

### buy_book
consumers can buy book in the bookshop with SUI

### GetBookInfoId
get book id

### GetBookInfoName
get book name

### GetBookInfoPrice
get book price

### GetBookInfoCount
get book counts

### GetBookInfoCreateAt
get book created timestamp

### GetBookInfoUpdateAt
get book updated timestamp

### GetBookInfoState
get book state for on-sale (BOOK_STATE_ON_SALE) or off-sale (BOOK_STATE_OFF_SALE)

### GetShopInfoPayAddress
get shop payment address

### GetBookNFTCount
get book nft counts

### GetBookNFTId
get book nft id

## UNITTEST
```bash
sui move test --skip-fetch-latest-git-deps

INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING bookshop
Running Move unit tests
[ PASS    ] 0x0::bookshop_tests::test_bookinfo
[ PASS    ] 0x0::bookshop_tests::test_bookshop_init
[ PASS    ] 0x0::bookshop_tests::test_buybook
Test result: OK. Total tests: 3; passed: 3; failed: 0
Please report feedback on the linter warnings at https://forums.sui.io
```