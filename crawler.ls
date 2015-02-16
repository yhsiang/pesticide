require! <[
  fs
  request
  cheerio
  lodash
]>
request = request.defaults jar: request.jar!
_ = lodash

# url = \http://pesticide.baphiq.gov.tw/web/Insecticides_MenuItem5_4.aspx?id=I201

viewstate = ""
eventvalidation = ""

# 補0
function padding (num)
  return "0#{num}" if num < 10
  return "#{num}"

# 擷取資料列表
function make-list (id, callback)
  err, res, body <- request.get "http://pesticide.baphiq.gov.tw/web/Insecticides_MenuItem5_4.aspx?id=#{id}"
  $ = cheerio.load body
  viewstate := $ '#__VIEWSTATE' .attr \value
  eventvalidation := $ '#__EVENTVALIDATION' .attr \value
  row = $ '#ctl00_ContentPlaceHolder1_GridView1 tr'
  lists = _.chunk (row.children 'td' .map((index, it) ->
    text = $ it .text!trim!
    if 0 is index % 12
      number = $ it .find 'a' .attr \href
      return "#{text}/#{number.match /([0-9]{7})[0-9]$/ .1}" unless number.match /^javascript/
    text
  ).to-array!), 12
  callback null, lists

# 下載標示檔
function download-images ({id, index, number}:options)
  eventargument = "ViewMark$#{index}"
  target = "ctl00$ContentPlaceHolder1$GridView1$ctl#{padding(index+2)}$HF_LNo"
  err, res, body <- request.post "http://pesticide.baphiq.gov.tw/web/Insecticides_MenuItem5_4.aspx?id=#{id}", do
    headers:
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.99 Safari/537.36'
    form:
      '__ASYNCPOST': 'true'
      'ctl00$ScriptManager1':'ctl00$ContentPlaceHolder1$UDPL01|ctl00$ContentPlaceHolder1$GridView1'
      '__EVENTTARGET': 'ctl00$ContentPlaceHolder1$GridView1'
      '__EVENTARGUMENT': eventargument
      # '__EVENTARGUMENT': 'ViewMark$' + index
      '__VIEWSTATE': viewstate
      '__EVENTVALIDATION': eventvalidation
      "#{target}": number
      # 'ctl00$ContentPlaceHolder1$GridView1$ctl' + padding(index+2) + '$HF_LNo': '1004408'

  err2, res2, body2 <- request.get "http://pesticide.baphiq.gov.tw/web/ViewMark.aspx"
  $ = cheerio.load body2
  index, it <- $ 'a' .each
  link = $ it .attr \href
  file-name = link.match /([0-9]{2}-[0-9]{5}-[0-9]{10}-[A-Z]{1}[0-9]{3}\.jpg)$/i .1
  request
    .get 'http://pesticide.baphiq.gov.tw/web/' + link
    .pipe fs.create-write-stream 'images/' + file-name


# 主程式
# 擷取列表 -> 個別下載標示檔
# TODO 爬分頁
fs.mkdir 'images' unless fs.exists-sync 'images'
err, it <- make-list \I201
row <- it.forEach
download-images do
  id: \I201
  index: 0
  number: row.0 .split '/' .1


