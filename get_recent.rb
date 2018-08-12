#get content
require 'rest-client'
require 'json'
require 'mongo'
TOKEN = '2.00cesKbC49eWNE3b55fa34f3ZIHDID'


def insert_weibo(token,client,last_id = nil)
  if last_id
    url = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=#{token}&count=100&since_id=#{last_id}"
  else
    url = "https://api.weibo.com/2/statuses/home_timeline.json?access_token=#{token}&count=100"
  end
  res = JSON.parse(RestClient.get(url)) 
  weibos =  res['statuses']
  
  if weibos.empty?
    return last_id
  else
    client[:weibo].insert_many weibos
    return weibos.first['id']
  end
end

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'starmap')

last_id = insert_weibo(TOKEN,client,'4272307796550988')
puts last_id