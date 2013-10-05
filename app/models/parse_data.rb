require "net/http"
require "uri"
class ParseData
  attr_reader :parse_app_id, :parse_rest_api_key
  def initialize
    @parse_app_id = PARSE_APP_ID
    @parse_rest_api_key = PARSE_REST_API_KEY     
    @transactional_batch = {}
  end  

  def parse_query(class_name,params=nil)
		puts ""
    puts "Quering to https://api.parse.com/1/classes/#{class_name}"
    puts "Parameter => #{params}"
    url = URI.parse("https://api.parse.com/1/classes/#{class_name}")
    req = create_api_connection(url,params,"get","json")
    res= get_results(req,url)
    begin
      returned_data = JSON.parse res.body                 
      results_data = returned_data["results"] || []   
    rescue
      results_data = []
    end
    
    return results_data
  end
  
  def parse_count(class_name,params)
    url = URI.parse("https://api.parse.com/1/classes/#{class_name}")
    req = create_api_connection(url,params,"get","query_string")
    res= get_results(req,url)
    begin
      returned_data = JSON.parse res.body
      results_data = returned_data["count"].to_i
    rescue
      results_data = 0
    end
    
    return results_data
  end

  def parse_get_object(class_name,id)                 
		puts ""
    url = URI.parse("https://api.parse.com/1/classes/#{class_name}/#{id}")
    req = create_api_connection(url,nil,"get","query_string")    
    res= get_results(req,url)
    returned_data = JSON.parse res.body
    return returned_data
  end

  def parse_create_object(class_name,params) 
		puts ""
    puts "Quering to https://api.parse.com/1/classes/#{class_name}"
    puts "Parameter => #{params}" 
    url = URI.parse("https://api.parse.com/1/classes/#{class_name}")
    req = create_api_connection(url,params,"post","json")
    res= get_results(req,url)
    returned_data = JSON.parse res.body
    return returned_data
  end

  def parse_update_object(class_name,id,params)
		puts ""
    puts "Quering to https://api.parse.com/1/classes/#{class_name}/#{id}"
    puts "Parameter => #{params}" 
    url = URI.parse("https://api.parse.com/1/classes/#{class_name}/#{id}")
    req = create_api_connection(url,params,"put","json")
    res= get_results(req,url)
    returned_data = JSON.parse res.body
    return returned_data
  end

  def parse_delete_object(class_name,id)
		puts ""
    url = URI.parse("https://api.parse.com/1/classes/#{class_name}/#{id}")
    req = create_api_connection(url,nil,"delete","query_string")
    res= get_results(req,url)
    returned_data = JSON.parse res.body
    return returned_data
  end

  def parse_push_notification(params)
		puts ""
    url = URI.parse("https://api.parse.com/1/push")
    req = create_api_connection(url,params,"post","json")
    res= get_results(req,url)
    returned_data = JSON.parse res.body
    return returned_data
  end
  
	#----Parse User Methods-----
  def parse_get_user(id)
		puts ""
		puts "Quering to => https://api.parse.com/1/users/#{id}"
    url = URI.parse("https://api.parse.com/1/users/#{id}")
    req = create_api_connection(url,nil,"get","query_string")
    res= get_results(req,url)
    returned_data = JSON.parse res.body           
    return returned_data["results"]
  end

  def parse_query_user(params=nil)       
		puts ""
		puts "Quering to => https://api.parse.com/1/users"      
		puts "Params=>#{params}"
    url = URI.parse("https://api.parse.com/1/users")
    req = create_api_connection(url,params,"get","json")
    res= get_results(req,url)          
    returned_data = JSON.parse res.body    
    return returned_data["results"]
  end

  def parse_create_user(params)            
		puts ""
    url = URI.parse("https://api.parse.com/1/users")  
    req = create_api_connection(url,params,"post","json")
    res= get_results(req,url)
    returned_data = JSON.parse res.body    
    return returned_data
  end   

  def parse_login_user(username,passwd)         
		puts ""
		puts "Quering to => https://api.parse.com/1/login"
	 	params = {:username => username, :password => passwd}
		url = URI.parse("https://api.parse.com/1/login")
    req = create_api_connection(url,params,"post","json")
    res= get_results(req,url)
    returned_data = JSON.parse res.body
    return returned_data
	 end
	#----Parse User Methods-----

  def get_results(req,url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.ca_file = 'lib/ca-bundle.crt'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    begin
      res= http.request(req)
    rescue
      res=nil
    end      
		puts "" 
		puts "Response =>#{JSON.parse res.body}"
    return res
  end
  
  def create_api_connection(url,params,method,params_format)
    puts ""
    puts "Quering to parse for method #{method}=>#{url}"
    puts "Params in JSON=>#{params.to_json}"
    if method=="post"
      req = Net::HTTP::Post.new(url.path)
    elsif method=="put"
      req = Net::HTTP::Put.new(url.path) 
    elsif method=="delete"
      req = Net::HTTP::Delete.new(url.path)
    else
      req = Net::HTTP::Get.new(url.path) 
    end                

    if params_format=="json"  
      req.body = params.to_json  if params
      req.set_content_type("application/json")
    else
      unless params.nil?
        req.set_form_data(params, ';')
      end
    end
    req.add_field("X-Parse-Application-Id", @parse_app_id)
    req.add_field("X-Parse-REST-API-Key", @parse_rest_api_key)
    return req
  end
  
  #def create_transactional_api_connection 

	#end


	def create_google_connection(url,params,method,params_format)
    if method=="post"
      req = Net::HTTP::Post.new(url.path)
    else
      req = Net::HTTP::Get.new(url.path) 
    end
  
    if params_format=="json"
      req.body = params.to_json
      req.set_content_type("application/json")
    else  
      unless params.nil?
        req.set_form_data(params, ';')
      end
    end
    
    return req
  end
  
  def get_short_url(long_url)
    url = URI.parse("https://www.googleapis.com/urlshortener/v1/url")
    params={
      'longUrl'=> long_url,
      'key'=> "AIzaSyBOB8hg5H977EaGKtSHDtYNrWBKQ5-Uq7Q"
    }
    req = create_google_connection(url,params,"post","json")
    res= get_results(req,url)
    returned_data = JSON.parse res.body
    return returned_data["id"]
  end

  def new_object_from_parse(klass,params)
    if !params.has_key?("objectId")
      return nil
    end
    if params.has_key?("createdAt")
      params["created_at"] = params["createdAt"]
      params.delete("createdAt")
    end
    
    if params.has_key?("updatedAt")
      params["updated_at"] = params["updatedAt"]
      params.delete("updatedAt")
    end                        
    
    entity = params.has_key?("className") ? params["className"].constantize.new : klass.constantize.new
    entity.id = rand(1000)
    entity.new_record = false  
    params.each do |k,v|
      if v.class == Hash 
        case v["__type"]
          when "Pointer"
            entity.send("#{(k.chomp("Id") << "_id")}=", v["objectId"])
          when "Date" 
            entity.send("#{k}=",  DateTime.parse(v["iso"]) )
          when "Object"
            entity.send("#{v["className"].downcase}=", new_from_parse(v))
          when "GeoPoint"
            entity.send("latitude_position=", v["latitude"])
            entity.send("longitude_position=", v["longitude"])
         end 
      else          
        if k == "objectId"        
          entity.parse_id = v
        else
          entity.send("#{k}=", v)
        end
      end
    end
    
    return entity
  end

end                                                                                                                                 