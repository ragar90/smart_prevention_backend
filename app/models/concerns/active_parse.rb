module ActiveParse
  extend ActiveSupport::Concern        

 def self.included(base)
   base.class_eval do 
		if self.class != User   
			  #Gets the dependents associations
			def get_dependants(association)
			  query_params = { 'where' => {"#{self.class.to_s.downcase}Id" => {"__type" => "Pointer","className" => "#{self.class.to_s}","objectId"=>self.parse_id}}.to_json}     
			  results = self.class.parse_query(query_params,association.to_s.singularize.camelize)
			end 
			self.reflect_on_all_associations(:has_many).map(&:name).each do |association_method|
	        alias_method "AR_#{association_method.to_s}".to_sym, association_method
	    end
		end
   end

	if self.class != User  
		association_methods = base.reflect_on_all_associations(:has_many).map(&:name).map{ |e| "def #{e.to_s} \n@#{e.to_s}||=get_dependants(\"#{e.to_s}\")\nend\ndef #{e.to_s}=(value) \n@#{e.to_s}=(value)end" }.join("\n\n")  
	   base.class_eval %Q"#{association_methods}"
	end
 end                  
   
  #Returns a hash containing all the attributes needed to create a parse object
  def to_parse_data 
    attrs = self.attributes    
    attrs.delete("parse_id")
    attrs.delete("id")  
    attrs.delete("created_at")
    attrs.delete("updated_at")   
    dates = attrs.select { |k,v| v.class == ActiveSupport::TimeWithZone }
    dates.each do |k,v| 
      attrs[k] = {"__type" => "Date", "iso" => v.iso8601(3)} 
    end
    latitude = self.latitude_position
    longitude = self.longitude_position
    if attrs.keys.include?("latitude_position") and attrs.keys.include?("longitude_position")
      attrs.delete("latitude_position")
      attrs.delete("longitude_position")
      attrs["position"] = {"__type" => "GeoPoint", "latitude" => latitude, "longitude" => longitude}
    end
    belongs_to_attrs = self.class.reflect_on_all_associations(:belongs_to).map(&:name).map{ |e| "#{e.to_s}" }
    belongs_to_attrs.each do |key|
      value = attrs["#{key}_id"]          
			camelized_key = key.downcase == "user" ? "_User" : key.camelize
      attrs["#{key}Id"] = {"__type" => "Pointer", "className" => camelized_key,"objectId" => value}   
      attrs.delete("#{key}_id")
    end
    return attrs
  end 
  #Save object to parse             
  def save_to_parse
    if self.valid?
      parser = ParseData.new(PARSE_APP_ID,PARSE_REST_API_KEY)   
      parse_attributes = self.to_parse_data      
      results = parser.parse_create_object(self.class.to_s,parse_attributes) 
      if results.has_key?("objectId")
        self.parse_id = results["objectId"]
        @new_record = false
        true
      else
        @new_record = true
        self.errors[:parse] << "Could not save the object to parse due to this error \" Error code: #{results["code"]}, Message: #{results["error"]} \""
        false
      end
    else 
      @new_record = true            
      false
    end 
  end  
  #Update object to parse    
  def update_to_parse 
    @new_record = false 
    if self.valid?   
      parser = ParseData.new(PARSE_APP_ID,PARSE_REST_API_KEY)   
      parse_attributes = self.to_parse_data
      results = parser.parse_update_object(self.class.to_s,self.parse_id,parse_attributes)
      if results.has_key?("updatedAt")
        ret_val = true
        self.class.reflect_on_all_associations(:has_many).map(&:name).map{ |e| e.to_s}.each do |dependent|
           self.send(dependent).each do |entity|     
            dependent_parse_attributes = entity.to_parse_data
            if entity.new_record?
              parser.parse_create_object(entity.class.to_s,dependent_parse_attributes)
            elsif entity.delete_me?                  
						 	 parser.parse_delete_object(entity.class.to_s,entity.parse_id)  
						else
              parser.parse_update_object(entity.class.to_s,entity.parse_id,dependent_parse_attributes)
            end
           end
        end 
        return true
      else
        return false
      end
    else
      false
    end
  end   
  
  def new_record=(value)
    @new_record = (value.class == TrueClass or value.class == FalseClass) ? value : false
  end
  
	def delete_me?
		(@delete_me == 1 or @delete_me == "1" or @delete_me == "true" or @delete_me == "TRUE" or @delete_me == true) ? true : false
	end

	def delete_me=(value)
		@delete_me = value
	end
  
  module ClassMethods
    
    #Returns a ParseData object  
    def parse_connection
      @@parser = ParseData.new(PARSE_APP_ID,PARSE_REST_API_KEY)
    end    
    
    def parse_query(query_params, klass=nil)
      klass ||=  self.to_s
      objects_results = []       
      parse_connection.parse_query(klass,query_params).each do |result| 
        objects_results << parse_connection.new_object_from_parse(klass,result)
      end
      return objects_results
    end
    
    #Returns all objects in Parse Table 
    def get_parse_all(args = {})
      puts args      
      params = {}
      if args[:include_parents]
        parents = reflect_on_all_associations(:belongs_to).map(&:name).map{ |e| "#{e.to_s}Id" } 
        params["include"] = parents.join(",")
      end
      
      if args[:order_by]  
        fields = args[:order_by][:fields].join(",") rescue args[:order_by][:fields]
        params["order"] = args[:order_by][:order].upcase == "DESC" ? "-#{fields}" : fields
      else
        params["order"] = "-createdAt"
      end      
      results = parse_connection.parse_query(self.to_s,params) 
      results.each do |entity|      
        val = entity["objectId"]
        entity.delete("objectId")
        entity["parse_id"] = val
      end
      
    end  
    
    #Finds and returns an object in Parse Table
    def find_in_parse(id)
      hash_object = parse_connection.parse_get_object(self.to_s,id)
      return new_from_parse(hash_object)
    end
    
    #Destroy and object in Parse Table
    def delete_from_parse(id)  
      dependents = self.reflect_on_all_associations(:has_many).map(&:name).map{ |e| "#{e.to_s.singularize.titleize}"}
      dependents.each do |dependent|       
        delete_dependent(dependent,id)
      end
      parse_connection.parse_delete_object(self.to_s,id)
    end
    
    def delete_dependent(klass,id)
    end
    
    #Returns an object instance base on Parse API response
    def new_from_parse(params)
      parse_connection.new_object_from_parse(self.to_s,params)
    end 

    def build_instance(params)
      associations = new_associations_from_hash(params)
      params.delete_if{ |key, value| key=~/([a-z]|\d)+_([a-z]|\d|)+_attributes$/}  
      new_instance = self.new(params)
      new_instance.new_record = new_instance.parse_id.blank?
      associations.each do |key, value|
        nested_association = key.to_s.split("_attributes").first
        new_instance.send("#{nested_association}=",  value )
      end
      return new_instance    
    end
    
    def new_associations_from_hash(params = {})
      unless params.empty?   
          nested_attributes = params.select{ |key, value| key=~/([a-z]|\d)+_([a-z]|\d|)+_attributes$/}
          
          nested_attributes.each do |k,v| 
            objects = []              
            klass = k.to_s.split("_attributes").first.singularize.camelize.constantize 
            v.each_value do |hash_object|
							destroy_it = hash_object["_destroy"] 
							hash_object.delete("_destroy")
              new_object = klass.new(hash_object)
							new_object.delete_me = destroy_it
              new_object.new_record= new_object.parse_id.blank?
              objects << new_object
            end  
            nested_attributes[k] = objects
          end
          return nested_attributes
      else 
        {}
      end
    end
  end
end            