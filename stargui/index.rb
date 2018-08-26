require 'sinatra'
require 'redis'

REDIS_KEY= 'weibos'

set :public_folder, File.dirname(__FILE__) + '/static'
#set :port, 80
set :environment, :production

$redis = Redis.new

use Rack::Auth::Basic, "starmap" do |username, password|
  username == 'admin' and password == 'admin'
end


def get_weibos_from_redis
  weibos = $redis.smembers REDIS_KEY
  weibos.sort! {|a,b| b['id'] <=> a['id'] }
  
  return weibos
end


get '/' do 
  weibos = get_weibos_from_redis
  weibos
end