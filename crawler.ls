require! <[
  fs
  request
  cheerio
]>
request = request.defaults jar: request.jar!

cols = <[
  id
  name
  brand
  type
  percentage
  up
  mix
  company
  originCompany
  availability
  note
  viewLink
]>

url = \http://pesticide.baphiq.gov.tw/web/Insecticides_MenuItem5_4.aspx?id=I201
url2 = \http://pesticide.baphiq.gov.tw/web/ViewMark.aspx

# err, res, body <- request.get url

# $ = cheerio.load body

# row = $ '#ctl00_ContentPlaceHolder1_GridView1 tr' .first!next!
# data = []
# while row.text!
#   data.push {[cols[i], d] for d, i in (row.children!map (, it) ->
#     $(it).text!trim!replace(/[\r|\n\ ]/g, "")
#   ).to-array!}
#   row .= next!

# form = do
#   form:
#     '__EVENTTARGET': 'ctl00$ContentPlaceHolder1$GridView1'
#     '__EVENTARGUMENT': 'ViewMark$0'
fs.mkdir 'images' unless fs.exists 'images'

err, res, body <- request.get url
$ = cheerio.load body
viewstate = $ '#__VIEWSTATE' .attr \value
eventvalidation = $ '#__EVENTVALIDATION' .attr \value

err2, res2, body2 <- request.post url, do
  headers:
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.99 Safari/537.36'
  form:
    '__ASYNCPOST': 'true'
    'ctl00$ScriptManager1':'ctl00$ContentPlaceHolder1$UDPL01|ctl00$ContentPlaceHolder1$GridView1'
    '__EVENTTARGET': 'ctl00$ContentPlaceHolder1$GridView1'
    '__EVENTARGUMENT': 'ViewMark$0'
    '__VIEWSTATE': viewstate
    '__EVENTVALIDATION': eventvalidation
    'ctl00$ContentPlaceHolder1$GridView1$ctl02$HF_LNo':'1004408'
    # 'ctl00$ContentPlaceHolder1$GridView1$ctl03$HF_LNo':'1004617'
    # 'ctl00$ContentPlaceHolder1$GridView1$ctl04$HF_LNo':'1004895'
    # 'ctl00$ContentPlaceHolder1$GridView1$ctl05$HF_LNo':'1004944'
    # 'ctl00$ContentPlaceHolder1$GridView1$ctl06$HF_LNo':'1004973'
    # 'ctl00$ContentPlaceHolder1$GridView1$ctl07$HF_LNo':'1004979'
    # 'ctl00$ContentPlaceHolder1$GridView1$ctl08$HF_LNo':'1004988'
    # 'ctl00$ContentPlaceHolder1$GridView1$ctl09$HF_LNo':'1005001'
    # 'ctl00$ContentPlaceHolder1$GridView1$ctl10$HF_LNo':'1005007'
    # 'ctl00$ContentPlaceHolder1$GridView1$ctl11$HF_LNo':'1005033'

err3, res3, body3 <- request.get url2 #, do
$ = cheerio.load body3
index, it <- $ 'a' .each
link = $ it .attr \href
file-name = link.match /([0-9]{2}-[0-9]{5}-[0-9]{10}-[A-Z]{1}[0-9]{3}.jpg)$/ .1
request
  .get 'http://pesticide.baphiq.gov.tw/web/' + link
  .pipe fs.create-write-stream 'images/' + file-name

