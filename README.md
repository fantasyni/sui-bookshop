# sui bookshop
this is an implementaion of bookshop through MOVE contract in sui blockchain.        
There are two roles in the bookshop, ``Admin`` and ``Consumer``  
``Admin`` manage the books, actions like add_bookinfo, update_bookinfo_name etc.  
``Consumer`` can buy book through ``buy_book`` move function.

## FUNCTION

### add_bookinfo
add book to the bookshop, it will make BookInfo share object, and emit AddBookEvent event

### update_bookinfo_name
update book name, it will emit AddBookEvent event

### update_bookinfo_price
update book price, it will emit UpdateBookPriceEvent event

### update_bookinfo_count
update book count, it will emit UpdateBookCountEvent event

### put_on_sale_bookinfo
update book state on sale, it will emit UpdateBookStateEvent event

### put_off_sale_bookinfo
update book state off sale, it will emit UpdateBookStateEvent event

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

## DEPLOY

### users
network: testnet  
admin: 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7  
buyer: 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4  
packgeId: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376  

### publish
```bash
export GAS_BUDGET=100000000
sui client publish --gas-budget $GAS_BUDGET

```bash
export GAS_BUDGET=100000000
sui client publish --gas-budget $GAS_BUDGET --skip-fetch-latest-git-deps

╭────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                         │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                       │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x0c286273a0db13f64fdd982a0eefb94907a9247344f1cf3eb0eb52c653cd58af                        │
│  │ Sender: 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7                          │
│  │ Owner: Shared                                                                                       │
│  │ ObjectType: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::ShopInfo  │
│  │ Version: 839095                                                                                     │
│  │ Digest: 7i6L1rfNTDWdX6qDZgxZLPDE2nHAtFMoseKMmsHnTouM                                                │
│  └──                                                                                                   │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x6437ae141c84a7820c32cca72c29d4b284222e81e263f3cc0f7ec159be2730bd                        │
│  │ Sender: 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7                          │
│  │ Owner: Account Address ( 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7 )       │
│  │ ObjectType: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::AdminCap  │
│  │ Version: 839095                                                                                     │
│  │ Digest: HXjiYyo9rxohoJ6CrH7DkVRgv27gGQ1xW7PEKLpd7Ejs                                                │
│  └──                                                                                                   │
│  ┌──                                                                                                   │
│  │ ObjectID: 0xcae3d2e3a5d0aec10a7281293fefb8b4d3c96b800c1ac5807849e4a86cc1bacf                        │
│  │ Sender: 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7                          │
│  │ Owner: Account Address ( 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7 )       │
│  │ ObjectType: 0x2::package::UpgradeCap                                                                │
│  │ Version: 839095                                                                                     │
│  │ Digest: 7zu1yHdYafsJMfjNGVZhXjn74wJLpTYkMNDTjPyo9SxE                                                │
│  └──                                                                                                   │
│ Mutated Objects:                                                                                       │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x778e44e14a9cfd6210b8845353fac22bd39bb7df65d4ef06f3c43d32a372e668                        │
│  │ Sender: 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7                          │
│  │ Owner: Account Address ( 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7 )       │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                          │
│  │ Version: 839095                                                                                     │
│  │ Digest: EC2iWa31bVvNE4m2YJqi13M86dRframFRNiG6cQNcVrj                                                │
│  └──                                                                                                   │
│ Published Objects:                                                                                     │
│  ┌──                                                                                                   │
│  │ PackageID: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376                       │
│  │ Version: 1                                                                                          │
│  │ Digest: 4F41y8rqu5asVPNnvB2Z8DCo4d8w1vSVp6wLkFNZeS6t                                                │
│  │ Modules: bookshop                                                                                   │
│  └──                                                                                                   │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────╯

export PACKAGE_ID=0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376
export ADMIN_CAP=0x6437ae141c84a7820c32cca72c29d4b284222e81e263f3cc0f7ec159be2730bd
export SHOP_INFO=0x0c286273a0db13f64fdd982a0eefb94907a9247344f1cf3eb0eb52c653cd58af
```

### Add Book
```bash
sui client call --function add_bookinfo --package $PACKAGE_ID --module bookshop --args $ADMIN_CAP "sui入门到精通" 12 5 0x6 --gas-budget $GAS_BUDGET

╭──────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                 │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                     │
│  │ EventID: HSRdqZ2cCjRQ1e2zsbE2gNkawkjWrSLZ2yqd6GwedJCX:0                                               │
│  │ PackageID: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376                         │
│  │ Transaction Module: bookshop                                                                          │
│  │ Sender: 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7                            │
│  │ EventType: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::AddBookEvent │
│  │ ParsedJSON:                                                                                           │
│  │   ┌─────────┬────────────────────────────────────────────────────────────────────┐                    │
│  │   │ book_id │ 0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf │                    │
│  │   ├─────────┼────────────────────────────────────────────────────────────────────┤                    │
│  │   │ count   │ 5                                                                  │                    │
│  │   ├─────────┼────────────────────────────────────────────────────────────────────┤                    │
│  │   │ name    │ sui入门到精通                                                      │                    │
│  │   ├─────────┼────────────────────────────────────────────────────────────────────┤                    │
│  │   │ price   │ 12                                                                 │                    │
│  │   ├─────────┼────────────────────────────────────────────────────────────────────┤                    │
│  │   │ state   │ 1                                                                  │                    │
│  │   └─────────┴────────────────────────────────────────────────────────────────────┘                    │
│  └──                                                                                                     │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                         │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                       │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf                        │
│  │ Sender: 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7                          │
│  │ Owner: Shared                                                                                       │
│  │ ObjectType: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::BookInfo  │
│  │ Version: 29507463                                                                                   │
│  │ Digest: 51CoJzjtMWDdszHPKwWhgusDqZetxJeeVPWWbraDKZBp                                                │
│  └──                                                                                                   │
│ Mutated Objects:                                                                                       │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x6437ae141c84a7820c32cca72c29d4b284222e81e263f3cc0f7ec159be2730bd                        │
│  │ Sender: 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7                          │
│  │ Owner: Account Address ( 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7 )       │
│  │ ObjectType: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::AdminCap  │
│  │ Version: 29507463                                                                                   │
│  │ Digest: CwvLC3HgfWWoNrJDX5hfRdGgoCVzXJcMubf6xjnY9nfD                                                │
│  └──                                                                                                   │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x778e44e14a9cfd6210b8845353fac22bd39bb7df65d4ef06f3c43d32a372e668                        │
│  │ Sender: 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7                          │
│  │ Owner: Account Address ( 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7 )       │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                          │
│  │ Version: 29507463                                                                                   │
│  │ Digest: HWXzbTcMghhig2nwx15RStoemyJzBiFWdgViLYc8QsP4                                                │
│  └──                                                                                                   │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────╯
export BOOKINFO=0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf

$ sui client object 0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf
╭───────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ objectId      │  0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf                                                   │
│ version       │  29507463                                                                                                             │
│ digest        │  51CoJzjtMWDdszHPKwWhgusDqZetxJeeVPWWbraDKZBp                                                                         │
│ objType       │  0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::BookInfo                               │
│ owner         │ ╭────────┬─────────────────────────────────────────╮                                                                  │
│               │ │ Shared │ ╭────────────────────────┬────────────╮ │                                                                  │
│               │ │        │ │ initial_shared_version │  29507463  │ │                                                                  │
│               │ │        │ ╰────────────────────────┴────────────╯ │                                                                  │
│               │ ╰────────┴─────────────────────────────────────────╯                                                                  │
│ prevTx        │  HSRdqZ2cCjRQ1e2zsbE2gNkawkjWrSLZ2yqd6GwedJCX                                                                         │
│ storageRebate │  1710000                                                                                                              │
│ content       │ ╭───────────────────┬───────────────────────────────────────────────────────────────────────────────────────────────╮ │
│               │ │ dataType          │  moveObject                                                                                   │ │
│               │ │ type              │  0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::BookInfo       │ │
│               │ │ hasPublicTransfer │  false                                                                                        │ │
│               │ │ fields            │ ╭───────────┬───────────────────────────────────────────────────────────────────────────────╮ │ │
│               │ │                   │ │ count     │  5                                                                            │ │ │
│               │ │                   │ │ create_at │  1713408615212                                                                │ │ │
│               │ │                   │ │ id        │ ╭────┬──────────────────────────────────────────────────────────────────────╮ │ │ │
│               │ │                   │ │           │ │ id │  0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf  │ │ │ │
│               │ │                   │ │           │ ╰────┴──────────────────────────────────────────────────────────────────────╯ │ │ │
│               │ │                   │ │ name      │  sui入门到精通                                                                │ │ │
│               │ │                   │ │ price     │  12                                                                           │ │ │
│               │ │                   │ │ state     │  1                                                                            │ │ │
│               │ │                   │ │ update_at │  1713408615212                                                                │ │ │
│               │ │                   │ ╰───────────┴───────────────────────────────────────────────────────────────────────────────╯ │ │
│               │ ╰───────────────────┴───────────────────────────────────────────────────────────────────────────────────────────────╯ │
╰───────────────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

```

### buy book
```bash
```bash

$ sui client gas
╭────────────────────────────────────────────────────────────────────┬────────────────────┬──────────────────╮
│ gasCoinId                                                          │ mistBalance (MIST) │ suiBalance (SUI) │
├────────────────────────────────────────────────────────────────────┼────────────────────┼──────────────────┤
│ 0x3aa285b4bc025d837e249aa5f25dbde7558ad566512497ee671cce66a76c75c6 │ 1000000000         │ 1.00             │
│ 0x7ebed229eb7ecc487692d845927b695bd8657bb48c91596972c8783ea714119e │ 1000000000         │ 1.00             │
╰────────────────────────────────────────────────────────────────────┴────────────────────┴──────────────────╯
export COIN=0x3aa285b4bc025d837e249aa5f25dbde7558ad566512497ee671cce66a76c75c6

sui client call --function buy_book --package $PACKAGE_ID --module bookshop --args $SHOP_INFO $BOOKINFO $COIN 3 0x6 --gas-budget $GAS_BUDGET

╭───────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Effects                                                                               │
├───────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Digest: D3UnpYmg58n9thmcYCNhRgCV2QVtKibCBv8uRhzSXh8p                                              │
│ Status: Success                                                                                   │
│ Executed Epoch: 343                                                                               │
│                                                                                                   │
│ Created Objects:                                                                                  │
│  ┌──                                                                                              │
│  │ ID: 0x17765d700ace05bd63138edf57a885a9013cadb6d9bc16667f922a80b159889b                         │
│  │ Owner: Account Address ( 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4 )  │
│  │ Version: 29508143                                                                              │
│  │ Digest: 6bKGZtjXTazZszEhqbDCTtth7MnvRUPnF8ZpGjZ88xz7                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0x43a5b59cfe661c8d0ed6e7e24942dcdcc077cb0265ccbe321614da7396230ffa                         │
│  │ Owner: Account Address ( 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4 )  │
│  │ Version: 29508143                                                                              │
│  │ Digest: DjDvuExd42Y9dJcXCHkyRRpckeF9XotLPQPdpau7mmrr                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0x95bcf077216e0716754b050b1d8a78956673fbba718c2614fd02e166a241ce8d                         │
│  │ Owner: Account Address ( 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7 )  │
│  │ Version: 29508143                                                                              │
│  │ Digest: D2gKnMwqwEnxFK5dZWwtxPXSji2kFbSgJj87o9n8WSMe                                           │
│  └──                                                                                              │
│ Mutated Objects:                                                                                  │
│  ┌──                                                                                              │
│  │ ID: 0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf                         │
│  │ Owner: Shared                                                                                  │
│  │ Version: 29508143                                                                              │
│  │ Digest: 82Jk9QmwxGjXkXkBarsVZtLHUUmujfWfRXjJzphvu9vJ                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0x7ebed229eb7ecc487692d845927b695bd8657bb48c91596972c8783ea714119e                         │
│  │ Owner: Account Address ( 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4 )  │
│  │ Version: 29508143                                                                              │
│  │ Digest: Cya6WTFPM6o7FMtFFvwYAYaU9TV2Yv2yEkLNPGTny7dS                                           │
│  └──                                                                                              │
│ Shared Objects:                                                                                   │
│  ┌──                                                                                              │
│  │ ID: 0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf                         │
│  │ Version: 29507463                                                                              │
│  │ Digest: 51CoJzjtMWDdszHPKwWhgusDqZetxJeeVPWWbraDKZBp                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0x0c286273a0db13f64fdd982a0eefb94907a9247344f1cf3eb0eb52c653cd58af                         │
│  │ Version: 839095                                                                                │
│  │ Digest: 7i6L1rfNTDWdX6qDZgxZLPDE2nHAtFMoseKMmsHnTouM                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0x0000000000000000000000000000000000000000000000000000000000000006                         │
│  │ Version: 29508142                                                                              │
│  │ Digest: 5g1gVZFNW2aT2kiMQGNTdGum1UwM1xkPckmWUBHdswHS                                           │
│  └──                                                                                              │
│ Deleted Objects:                                                                                  │
│  ┌──                                                                                              │
│  │ ID: 0x3aa285b4bc025d837e249aa5f25dbde7558ad566512497ee671cce66a76c75c6                         │
│  │ Version: 29508143                                                                              │
│  │ Digest: 7gyGAp71YXQRoxmFBaHxofQXAipvgHyBKPyxmdSJxyvz                                           │
│  └──                                                                                              │
│ Gas Object:                                                                                       │
│  ┌──                                                                                              │
│  │ ID: 0x7ebed229eb7ecc487692d845927b695bd8657bb48c91596972c8783ea714119e                         │
│  │ Owner: Account Address ( 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4 )  │
│  │ Version: 29508143                                                                              │
│  │ Digest: Cya6WTFPM6o7FMtFFvwYAYaU9TV2Yv2yEkLNPGTny7dS                                           │
│  └──                                                                                              │
│ Gas Cost Summary:                                                                                 │
│    Storage Cost: 6346000 MIST                                                                     │
│    Computation Cost: 1000000 MIST                                                                 │
│    Storage Rebate: 3649140 MIST                                                                   │
│    Non-refundable Storage Fee: 36860 MIST                                                         │
│                                                                                                   │
│ Transaction Dependencies:                                                                         │
│    3Cwu7jaGSrXmdgVN4hWLwNQ4B2WftHSfXeK3suYcLrcY                                                   │
│    9bdwxUgPX4QbH2oPutiodHSFZKFcoxhAXnkC6vAkhqHm                                                   │
│    BmkDAE8fhkGYREmycpkamQszcmJyECitRCWphAqH8d2i                                                   │
│    FZYSGNK6q136ZX86E672QgGCevvYBpky9W32V3biEveP                                                   │
│    HSRdqZ2cCjRQ1e2zsbE2gNkawkjWrSLZ2yqd6GwedJCX                                                   │
╰───────────────────────────────────────────────────────────────────────────────────────────────────╯
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                 │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                     │
│  │ EventID: D3UnpYmg58n9thmcYCNhRgCV2QVtKibCBv8uRhzSXh8p:0                                               │
│  │ PackageID: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376                         │
│  │ Transaction Module: bookshop                                                                          │
│  │ Sender: 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4                            │
│  │ EventType: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::BuyBookEvent │
│  │ ParsedJSON:                                                                                           │
│  │   ┌────────────┬────────────────────────────────────────────────────────────────────┐                 │
│  │   │ book_count │ 3                                                                  │                 │
│  │   ├────────────┼────────────────────────────────────────────────────────────────────┤                 │
│  │   │ book_id    │ 0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf │                 │
│  │   ├────────────┼────────────────────────────────────────────────────────────────────┤                 │
│  │   │ create_at  │ 1713409291710                                                      │                 │
│  │   └────────────┴────────────────────────────────────────────────────────────────────┘                 │
│  └──                                                                                                     │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                         │
├────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                       │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x17765d700ace05bd63138edf57a885a9013cadb6d9bc16667f922a80b159889b                        │
│  │ Sender: 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4                          │
│  │ Owner: Account Address ( 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4 )       │
│  │ ObjectType: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::BookNFT   │
│  │ Version: 29508143                                                                                   │
│  │ Digest: 6bKGZtjXTazZszEhqbDCTtth7MnvRUPnF8ZpGjZ88xz7                                                │
│  └──                                                                                                   │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x43a5b59cfe661c8d0ed6e7e24942dcdcc077cb0265ccbe321614da7396230ffa                        │
│  │ Sender: 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4                          │
│  │ Owner: Account Address ( 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4 )       │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                          │
│  │ Version: 29508143                                                                                   │
│  │ Digest: DjDvuExd42Y9dJcXCHkyRRpckeF9XotLPQPdpau7mmrr                                                │
│  └──                                                                                                   │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x95bcf077216e0716754b050b1d8a78956673fbba718c2614fd02e166a241ce8d                        │
│  │ Sender: 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4                          │
│  │ Owner: Account Address ( 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7 )       │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                          │
│  │ Version: 29508143                                                                                   │
│  │ Digest: D2gKnMwqwEnxFK5dZWwtxPXSji2kFbSgJj87o9n8WSMe                                                │
│  └──                                                                                                   │
│ Mutated Objects:                                                                                       │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf                        │
│  │ Sender: 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4                          │
│  │ Owner: Shared                                                                                       │
│  │ ObjectType: 0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::BookInfo  │
│  │ Version: 29508143                                                                                   │
│  │ Digest: 82Jk9QmwxGjXkXkBarsVZtLHUUmujfWfRXjJzphvu9vJ                                                │
│  └──                                                                                                   │
│  ┌──                                                                                                   │
│  │ ObjectID: 0x7ebed229eb7ecc487692d845927b695bd8657bb48c91596972c8783ea714119e                        │
│  │ Sender: 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4                          │
│  │ Owner: Account Address ( 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4 )       │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                          │
│  │ Version: 29508143                                                                                   │
│  │ Digest: Cya6WTFPM6o7FMtFFvwYAYaU9TV2Yv2yEkLNPGTny7dS                                                │
│  └──                                                                                                   │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭───────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Balance Changes                                                                                   │
├───────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                              │
│  │ Owner: Account Address ( 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7 )  │
│  │ CoinType: 0x2::sui::SUI                                                                        │
│  │ Amount: 36                                                                                     │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ Owner: Account Address ( 0xf659e4dff81e081f7c5dc4f82a93c050fc7c58fc669f1b1c00c4a75b5b89f1c4 )  │
│  │ CoinType: 0x2::sui::SUI                                                                        │
│  │ Amount: -3696896                                                                               │
│  └──                                                                                              │
╰───────────────────────────────────────────────────────────────────────────────────────────────────╯

```

```bash
$ sui client object 0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf
╭───────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ objectId      │  0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf                                                   │
│ version       │  29508143                                                                                                             │
│ digest        │  82Jk9QmwxGjXkXkBarsVZtLHUUmujfWfRXjJzphvu9vJ                                                                         │
│ objType       │  0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::BookInfo                               │
│ owner         │ ╭────────┬─────────────────────────────────────────╮                                                                  │
│               │ │ Shared │ ╭────────────────────────┬────────────╮ │                                                                  │
│               │ │        │ │ initial_shared_version │  29507463  │ │                                                                  │
│               │ │        │ ╰────────────────────────┴────────────╯ │                                                                  │
│               │ ╰────────┴─────────────────────────────────────────╯                                                                  │
│ prevTx        │  D3UnpYmg58n9thmcYCNhRgCV2QVtKibCBv8uRhzSXh8p                                                                         │
│ storageRebate │  1710000                                                                                                              │
│ content       │ ╭───────────────────┬───────────────────────────────────────────────────────────────────────────────────────────────╮ │
│               │ │ dataType          │  moveObject                                                                                   │ │
│               │ │ type              │  0x399215e7c4ce2d5cbb37a41a7c2d5319e318e0b0681ead34721b312e28ef5376::bookshop::BookInfo       │ │
│               │ │ hasPublicTransfer │  false                                                                                        │ │
│               │ │ fields            │ ╭───────────┬───────────────────────────────────────────────────────────────────────────────╮ │ │
│               │ │                   │ │ count     │  2                                                                            │ │ │
│               │ │                   │ │ create_at │  1713408615212                                                                │ │ │
│               │ │                   │ │ id        │ ╭────┬──────────────────────────────────────────────────────────────────────╮ │ │ │
│               │ │                   │ │           │ │ id │  0x09fea25143d49f000c005dd89d6516cb73b1177b356e6c278b6073e8be5c57bf  │ │ │ │
│               │ │                   │ │           │ ╰────┴──────────────────────────────────────────────────────────────────────╯ │ │ │
│               │ │                   │ │ name      │  sui入门到精通                                                                │ │ │
│               │ │                   │ │ price     │  12                                                                           │ │ │
│               │ │                   │ │ state     │  1                                                                            │ │ │
│               │ │                   │ │ update_at │  1713408615212                                                                │ │ │
│               │ │                   │ ╰───────────┴───────────────────────────────────────────────────────────────────────────────╯ │ │
│               │ ╰───────────────────┴───────────────────────────────────────────────────────────────────────────────────────────────╯ │
╰───────────────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

```

### switch to admin address
```bash
sui client switch --address 0x27067bf2d9988d7beff9c0278c49548d39eb38978905bbcbe39d2bf2ee18d4a7
$ sui client gas
╭────────────────────────────────────────────────────────────────────┬────────────────────┬──────────────────╮
│ gasCoinId                                                          │ mistBalance (MIST) │ suiBalance (SUI) │
├────────────────────────────────────────────────────────────────────┼────────────────────┼──────────────────┤
│ 0x94a6baa7d4e8923d4bf991801ee0683154d7cd13c3427889b00915066091108b │ 1000000000         │ 1.00             │
│ 0x95bcf077216e0716754b050b1d8a78956673fbba718c2614fd02e166a241ce8d │ 36                 │ 0.00             │
╰────────────────────────────────────────────────────────────────────┴────────────────────┴──────────────────╯

```