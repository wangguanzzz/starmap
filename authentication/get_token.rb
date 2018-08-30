require 'open-uri'
require 'json'
CLIENT_ID = '3864405711'
SECRET='676f25c9a7b30d1f38854aa50d5053a4'
REDIRECT_URI='http://127.0.0.1'

CODE = ARGV[0]


command = "curl -d \"client_id=#{CLIENT_ID}&client_secret=#{SECRET}&grant_type=authorization_code&redirect_uri=#{REDIRECT_URI}&code=#{CODE}\" \"https://api.weibo.com/oauth2/access_token\""
res = `#{command}`
puts res
