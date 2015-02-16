# 農藥許可證標示檔下載器

A crawler for downloading image files from [農藥資訊服務網](http://pesticide.baphiq.gov.tw/web/Insecticides_MenuItem5_4.aspx)

# 開發

需求 nodejs

1. `$ npm install`
2. `$ lsc crawler.ls`

# 流程

1. 讀取 http://pesticide.baphiq.gov.tw/web/Insecticides_MenuItem5_4.aspx?id=I201
2. 計算總頁數 和 每頁個數
3. 抓取 list
4. 下載圖檔
5. 換頁 `'__EVENTARGUMENT': 'Page$2'`
6. 重複 2,3

# TODO

1. 流程 2
2. 流程 5
3. 流程 6


# LICENSE

CC0