require 'open-uri'
CLIENT_ID = '3864405711'
SECRET='676f25c9a7b30d1f38854aa50d5053a4'
REDIRECT_URI='http://127.0.0.1'

CODE = ARGV[0]


command = "curl -d \"client_id=#{CLIENT_ID}&client_secret=#{SECRET}&grant_type=authorization_code&redirect_uri=#{REDIRECT_URI}&code=#{CODE}\" \"https://api.weibo.com/oauth2/access_token\""
res = `#{command}`
puts res
#puts HTTP.get("http://www.baidu.com").to_s


#get content
#https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00cesKbC49eWNE3b55fa34f3ZIHDID
