# only work with version 0.3
require 'aliyun/oss'

class StarOss

  def load(keyfile)
  # 1 key id
  # 2 secret key
  # 3 endpoint
  # 4 bucket name
    res = []
    File.readlines(keyfile).each do |line|
      line = line.strip
      res << line
    end
    @access_key_id , @access_key_secret, @endpoint, @bucket_name = res
  end
  
  def oss_put(file,topic='default')
    key = oss_create_key(file,topic)
    client = Aliyun::OSS::Client.new(
      :endpoint => @endpoint,
      :access_key_id => @access_key_id,
      :access_key_secret => @access_key_secret)

    bucket = client.get_bucket @bucket_name
    bucket.put_object(key,:file => file)
  end

  #@ return valid key 
  def oss_create_key(file,topic='default')
    basename = File.basename(file)
    head = Time.now.strftime('%y-%m-%d %H:%M')
    return head+'_'+topic+'_'+basename
  end

end


startstore = StarOss.new
startstore.load('/home/chriswang/keyfile.txt')
file = '/home/chriswang/Documents/cost_p3/12.jpg'
startstore.oss_put file,'mysteel'