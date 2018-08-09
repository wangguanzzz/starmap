require 'http'
require 'open-uri'
CLIENT_ID = '3864405711'
SECRET='676f25c9a7b30d1f38854aa50d5053a4'
REDIRECT_URI='http://127.0.0.1'

CODE = 'db74b6625b97c2b39d05d96dfd8feace'
url1 = "https://api.weibo.com/oauth2/authorize?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}"
url2 = "https://api.weibo.com/oauth2/access_token?client_id=#{CLIENT_ID}&client_secret=#{SECRET}&grant_type=authorization_code&redirect_uri=#{REDIRECT_URI}&code=#{CODE}"
puts url1
puts url2
# get access token
#curl -d "client_id=3864405711&client_secret=676f25c9a7b30d1f38854aa50d5053a4&grant_type=authorization_code&redirect_uri=http://127.0.0.1&code=db74b6625b97c2b39d05d96dfd8feace" "https://api.weibo.com/oauth2/access_token"
#puts HTTP.get("http://www.baidu.com").to_s


#get content
https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00cesKbC49eWNE3b55fa34f3ZIHDID
