# -*- coding: UTF-8 -*-
require 'rest-client'

FUTURES_MAP={'M0' => '豆粕连续','P0' => '棕榈连续','RU0' => '橡胶连续'}
FUTURES = ['M0','P0','RU0']

URL = 'http://hq.sinajs.cn/list='

def get_volume(str)
  res = str.split ','
  return res[14]
end

def get_price(str)
  res = str.split ','
  return res[8]
end
FUTURES.each do |ft|
  res = RestClient.get(URL+ft)
  puts FUTURES_MAP[ft]
  puts get_price res
  puts get_volume res
end