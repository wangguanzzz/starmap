#encoding: utf-8

require 'rest-client'
require 'json'
require 'redis'
FUTURES_MAP={ 'SR0'=>'白糖连续', 'M0' => '豆粕连续','C0'=>'玉米连续','Y0'=>'豆油连续','P0' => '棕榈连续','RU0' => '橡胶连续'}
FUTURES = ['M0','P0','RU0']
FUTURE_INTERVAL = 20
URL = 'http://hq.sinajs.cn/list='

#set
REDIS_FUTURES= 'futures_list'

class Futurelist
  attr_accessor :name,:id

private
  def add(arr,obj)
    arr.unshift obj
    arr.pop if arr.size > 10
  end

  def delta_level(arr,level)
    ref = arr.first.to_f
    comp = arr[level].to_f
    return (ref - comp)/comp*100
  end

  def get_volume(str)
    res = str.split ','
    return res[14].to_f
  end

  def get_price(str)
    res = str.split ','
    return res[8].to_f
  end

  def add_price(p)
    add @price, p
  end

  def add_volume(v)
    add @volume, v
  end

public
  def initialize(id,name)
    @name = name
    @id = id
    @price = []
    @volume = []
    @status = ""
  end




  def price_delta_level(level)
    if @price.first and @price[level]
      return delta_level(@price,level)
    else
      return 0
    end
  end

  def volume_delta_level(level)
    if @volume.first and @volume[level]
      return delta_level(@volume,level)
    else
      return 0
    end
  end

  def refresh
    @status = RestClient.get(URL+@id).unpack('C*').pack('U*')
    price = get_price @status
    volume = get_volume @status
    add_price price
    add_volume volume
  end
end

fls = [] 
FUTURES_MAP.each do |key,value|
  fls << Futurelist.new(key,value)
end

redis = Redis.new

while(true)
  sleep FUTURE_INTERVAL
  fls.each {|fl| fl.refresh }
  fls.each do |fl|
    res =  {}
    res[:name] = fl.name
    res[:id] = fl.id
    res[:price_level1] =fl.price_delta_level 1
    res[:price_level3] = fl.price_delta_level 3
    res[:price_level5] = fl.price_delta_level 5
    res[:volume_level1] = fl.volume_delta_level 1
    res[:volume_level3] = fl.volume_delta_level 3
    res[:volume_level5] = fl.volume_delta_level 5
    redis.sadd REDIS_FUTURES, res[:id]
    redis.set res[:id], res.to_json
  end
  
end


#FUTURES.each do |ft|
#  res = RestClient.get(URL+ft)
#  puts FUTURES_MAP[ft]
#  puts get_price res
#  puts get_volume res
#end