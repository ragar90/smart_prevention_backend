class Zone < ActiveRecord::Base
	include ActiveParse
	include GeoSearch
	#longitude=>13.690148
	#latitude=>-89.24296
	def self.arround(position)
		range = geo_perimeter(position,2)
		results = self.parse_query
		results.select{|result| result.inside_range?(range)}
	end
end