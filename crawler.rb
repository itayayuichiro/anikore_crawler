require 'net/http'
require 'uri'
# Nokogiriを使うの追加
require 'nokogiri'

uri = URI.parse("https://www.anikore.jp/chronicle/2020/spring/ac:tv/")
request = Net::HTTP::Get.new(uri)
request["Authority"] = "www.anikore.jp"
request["Cache-Control"] = "max-age=0"
request["Upgrade-Insecure-Requests"] = "1"
request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.116 Safari/537.36"
request["Sec-Fetch-Dest"] = "document"
request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
request["Sec-Fetch-Site"] = "same-origin"
request["Sec-Fetch-Mode"] = "navigate"
request["Sec-Fetch-User"] = "?1"
request["Referer"] = "https://www.anikore.jp/"
request["Accept-Language"] = "ja,en-US;q=0.9,en;q=0.8,zh-TW;q=0.7,zh;q=0.6"
request["Cookie"] = "anikore=vr4e4jp9u83qpe76nb5jf2dm35; optimizelyEndUserId=oeu1591020303990r0.9278880352532264; optimizelySegments=%7B%225639900384%22%3A%22gc%22%2C%225644680362%22%3A%22direct%22%2C%225653460252%22%3A%22false%22%7D; optimizelyBuckets=%7B%7D; _ga=GA1.2.1594135381.1591020306; __gads=ID=8dec67eec678ab98:T=1591020306:S=ALNI_Mam9k84TCb2IJVyBUucjbUoYYIgsQ; _gid=GA1.2.1570502140.1591280281; _gali=page-top; _gat=1"

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

# 受け取ったHTMLをパースする
doc = Nokogiri::HTML.parse(response.body, nil, nil)

# パースされた情報から必要な情報を抽出
doc.css(".l-searchPageRanking_unit").each{|div|
    puts "タイトル:" + div.css(".l-searchPageRanking_unit_title")[0].text.split("\n")[2].gsub("              ","")
    puts "評価:" + div.css(".l-searchPageRanking_unit_mainBlock_starPoint strong")[0].text
    puts "コメント数:" + div.css(".l-searchPageRanking_unit_mainBlock_starPoint span")[0].text + "\n\n"
}