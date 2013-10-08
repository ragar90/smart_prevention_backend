class Zone < ActiveRecord::Base
	include GeoSearch
	validates :latitude_position, :longitude_position, :name,:presence=>true
	def self.arround(position)
		range = geo_perimeter(position,2)
		results = self.all
		results.select{|result| result.inside_range?(range)}
	end
end