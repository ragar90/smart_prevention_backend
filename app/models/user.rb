class User < ActiveRecord::Base
	include ActiveParse
	include GeoSearch

	def set_new_locations(params)
		Position.create(user_id: self.id, latitude: self.last_latitude_position, longitud: self.last_longitude_position)
		last_latitude_position = params[:latitude]
		last_longitude_position = params[:longitude]
		self.update_to_parse
	end

	def self.get_arround_alerts(position)
		range = geo_perimeter(position,2)
		results = self.get_all_users
		results.select{|result| result.inside_range?(range)}
	end

	def self.get_filtered_alerts(filters)
		results = self.get_all_users
		results.select{|result| result.emergency_state == filters[:status]}
	end

	def self.get_filtered_arround_alerts(position, filters)
		range = geo_perimeter(position,2)
		results = self.get_all_users
		results.select{|result| result.inside_range?(range) and result.emergency_state == filters[:status]}
	end

	def self.get_all_users
		self.parse_connection.parse_query_user.map{|result| new_from_parse(result)}
	end


end


