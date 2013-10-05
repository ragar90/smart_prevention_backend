module GeoSearch
	extend ActiveSupport::Concern   

	module ClassMethods
		def geo_perimeter(center,distance)
			latitude_equivalence = 111.044736
			range = {longitude:{min: 0,max: 0}, latitude:{min:0, max: 0}}
			radian_latitud = center[:latitude] * Math::PI/180
			range[:longitude][:min] = center[:longitude] - (distance/ (Math.cos(radian_latitud).abs * latitude_equivalence) )
			range[:longitude][:max] = center[:longitude] + (distance/ (Math.cos(radian_latitud).abs * latitude_equivalence) )
			range[:latitude][:min] = center[:latitude] - (distance/ latitude_equivalence )
			range[:latitude][:max] = center[:latitude] + (distance/ latitude_equivalence )
			return range
		end
	end

	def inside_range?(range)
		longitude_match = (longitude_position>=range[:longitude][:min] and longitude_position<=range[:longitude][:max])
		latitude_match = (latitude_position>=range[:latitude][:min] and latitude_position<=range[:latitude][:max])
		return (longitude_match and latitude_match )
	end
end