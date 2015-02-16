# 農藥許可證標示檔下載器

A crawler for downloading image files from [農藥資訊服務網](http://pesticide.baphiq.gov.tw/web/Insecticides_MenuItem5_4.aspx)

# 開發

需求 nodejs

1. `$ npm install`
2. `$ lsc crawler.ls`

# 流程

設定想抓取的農藥代號 crawler.ls#L101

1. read-first 存 viewstate, eventvalidation, 計算總頁數 `pages` 和 每頁個數 `entries`
2. 抓取 list 和 下載圖檔
3. 從第二頁到最後一頁
4. 重複 2

# TODO

1. 驗證 crawler 是否能抓取全部圖檔
2. 產生相對應農藥名與圖檔名稱的 json 檔
3. 抓取全部的農藥資訊

# LICENSE

CC0