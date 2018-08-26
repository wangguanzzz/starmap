#get content
require 'rest-client'
require 'json'
require 'mongo'
require 'redis'
TOKEN = '2.00cesKbC49eWNE3b55fa34f3ZIHDID'
REDIS_KEY= 'weibos'
LAST_ID_KEY= 'weibo_lastid'

def get_weibos(token,last_id = nil)
#client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'starmap')
  if last_id
    url = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=#{token}&count=100&since_id=#{last_id}"
  else
    url = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=#{token}&count=100"
  end
  res = JSON.parse(RestClient.get(url)) 
  return  res['statuses']
end

def insert_weibo_into_mongo(client,weibos)
    client[:weibo].insert_many weibos
end

def insert_weibo_into_redis(redis,weibos)
  weibos.each do |weibo|
    redis.sadd REDIS_KEY,weibo.to_json
  end
end



redis = Redis.new
last_id = nil
while(true)
  weibos = get_weibos(TOKEN,last_id)
  last_id = weibos.first['id'] if not weibos.empty?
  insert_weibo_into_redis(redis,weibos)
  puts "#{weibos.size} weibos added !"
  sleep 30
end