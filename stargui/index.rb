# -*- coding: UTF-8 -*-
require 'sinatra'
require 'redis'

REDIS_KEY= 'weibos'
REDIS_FUTURES= 'futures_list'
set :public_folder, File.dirname(__FILE__) + '/static'
#set :port, 80
set :environment, :production

$redis = Redis.new

use Rack::Auth::Basic, "starmap" do |username, password|
  username == 'admin' and password == 'admin'
end


def get_weibos_from_redis
  weibos = []
  ids = $redis.smembers REDIS_KEY
  ids.each {|id|  weibos << JSON.parse($redis.get id.to_s) if $redis.get id.to_s }
  return weibos
end

def get_futures_from_redis
  futures = []
  ids = $redis.smembers REDIS_FUTURES
  ids.each do |fid|
    future = JSON.parse($redis.get fid)
    futures << future
  end
  return futures
end


def remove_weibo(id)
  $redis.srem REDIS_KEY, id
  $redis.del id.to_s
end

def remove_weibo_from_word(word)
  weibos = get_weibos_from_redis
  
  weibos.each do |weibo|
    if weibo['text'].include? word
      remove_weibo weibo['id']
    end
  end
end


#def add_link(str)
#  ind = (str =~ /http:/)
#  if ind
#    temp = str[ind..-1]
#    temp = temp.split ' '
#    temp = temp.first
#    str[temp] = "<a href=\"#{temp}\">"+temp+"</a>"
#    return str
#  else
#    return str
#  end
#end

get '/' do 
  weibos = get_weibos_from_redis
  weibos.sort! {|a,b| b['id'] <=> a['id'] }

  futures = get_futures_from_redis
  price1_top3 = (futures.sort{|a,b| b['price_level1'].abs <=> a['price_level1'].abs })[0..2]
  price2_top3 = (futures.sort{|a,b| b['price_level3'].abs <=> a['price_level3'].abs })[0..2]
  volume1_top3 = (futures.sort!{|a,b| b['volume_level1'].abs <=> a['volume_level1'].abs })[0..2]
  volume2_top3 = (futures.sort!{|a,b| b['volume_level3'].abs <=> a['volume_level3'].abs })[0..2]
#  weibos.each do |w|
#    puts w if w['id'] == 4277762690256519
#  end
  erb :weibo, :locals => {weibos: weibos,price1_top3: price1_top3, volume1_top3: volume1_top3,price2_top3: price2_top3, volume2_top3: volume2_top3 }
  #weibos = get_weibos_from_redis
  #weibos
end



get '/byebye/:weiboid' do
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  id = params['weiboid'].to_i
  remove_weibo(id)
end

# remove the key words text weibos
get '/delete/:word' do
  word = params['word']
  remove_weibo_from_word word
end