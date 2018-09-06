#encoding: utf-8

require 'rest-client'
require 'json'
require 'redis'
FUTURES_MAP={ 'CU0'=>'铜连续','AL0'=>'铝连续','ZN0'=>'锌连续','PB0'=>'铅连续','FU0' => '燃料油连续','HC0'=>'热卷连续','NI0'=>'镍连续','RB0'=>'螺纹钢连续', \
  'I0'=>'铁矿石连续','J0'=>'焦炭连续', 'JD0' =>'鸡蛋连','RI0' =>'玻璃连续','RM0'=>'菜粕连续','TA0'=>'PTA连续','AP0'=>'苹果连续', \
  'SN0'=>'锡连续','A0'=>'豆1连续','B0'=>'豆2连续','SR0'=>'白糖连续', 'M0' => '豆粕连续','C0'=>'玉米连续','Y0'=>'豆油连续', \
  'P0' => '棕榈连续','RU0' => '橡胶连续','FG0' => '玻璃连续','CF0' => '棉花连续', 'WS0' => '强麦连续','AO0' => '菜籽油连续','BU0'=> '沥青连续' }
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
    return 0 if comp == 0
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
    begin
      @status = RestClient.get(URL+@id).unpack('C*').pack('U*')
    rescue Exception => e
      puts @name + " is not accessible" 
    end
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
  start_time = Time.now
  fls.each {|fl| fl.refresh }
  elaspe = Time.now - start_time
  puts elaspe

  fls.each do |fl|
    res =  {}
    res[:name] = fl.name
    res[:id] = fl.id
    res[:time] = start_time.to_i
    res[:price_level1] =fl.price_delta_level 1
    res[:price_level3] = fl.price_delta_level 3
    res[:price_level5] = fl.price_delta_level 5
    res[:volume_level1] = fl.volume_delta_level 1
    res[:volume_level3] = fl.volume_delta_level 3
    res[:volume_level5] = fl.volume_delta_level 5
    redis.sadd REDIS_FUTURES, res[:id]
    redis.set res[:id], res.to_json
  end
  
  if FUTURE_INTERVAL > elaspe.to_i
    sleep FUTURE_INTERVAL - elaspe.to_i
  else
    sleep FUTURE_INTERVAL
  end
end

