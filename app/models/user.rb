class User < ActiveRecord::Base
	include ActiveParse
	validates :name, :email,:blood_type, :home_addres, :emergency_contact_number, presence: true
	def set_new_locations(params)
		Position.create(user_id: self.id, latitude: self.last_latitude_position, longitud: self.last_longitude_position)
		last_latitude_position = params[:latitude]
		last_longitude_position = params[:longitude]
		self.save_to_parse
	end
end
