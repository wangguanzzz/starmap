require 'sinatra'

set :public_folder, File.dirname(__FILE__) + '/static'
#set :port, 80
set :environment, :production

use Rack::Auth::Basic, "starmap" do |username, password|
  username == 'admin' and password == 'admin'
end

get '/' do 
  'hello world'
end