require 'open-uri'
CLIENT_ID = '3864405711'
SECRET='676f25c9a7b30d1f38854aa50d5053a4'
REDIRECT_URI='http://127.0.0.1'

url1 = "https://api.weibo.com/oauth2/authorize?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}"
puts url1

