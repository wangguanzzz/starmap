#get content
require 'rest-client'
require 'json'
TOKEN = '2.00cesKbC49eWNE3b55fa34f3ZIHDID'

url = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=#{TOKEN}&count=100&since_id=4271483859831950"

res = RestClient.get url
res = JSON.parse res
weibos =  res['statuses']
weibos.each do |weibo|
	puts 'id'
	puts weibo['id']
#	puts "text:"
#	puts weibo['text']
#	puts "user:"
#	puts weibo['user']['name']
end