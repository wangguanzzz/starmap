# -*- coding: UTF-8 -*-
#get content
require 'rest-client'
require 'json'
require 'mongo'
require 'redis'
TOKEN = ARGV[0]
REDIS_KEY= 'weibos'
LAST_ID = 'weibo_lastid'

def get_weibos(token,last_id = nil)
#client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'starmap')
  if last_id
    url = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=#{token}&count=100&since_id=#{last_id}"
  else
    url = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=#{token}&count=100"
    puts url
  end
  res = JSON.parse(RestClient.get(url)) 
  return  res['statuses']
end

def insert_weibo_into_mongo(client,weibos)
    client[:weibo].insert_many weibos
end

def insert_weibo_into_redis(redis,weibos)
  weibos.each do |weibo|
    redis.sadd REDIS_KEY,weibo['id']
    redis.set weibo['idstr'], weibo.to_json
  end
end



redis = Redis.new
last_id = redis.get LAST_ID
while(true)
  weibos = get_weibos(TOKEN,last_id)
  if not weibos.empty?
    last_id = weibos.first['id']
    redis.set LAST_ID, last_id
    puts "last_id: #{last_id}"
    puts 7.chr
  end
  insert_weibo_into_redis(redis,weibos)
  puts "#{weibos.size} weibos added !"
  sleep 120
end
