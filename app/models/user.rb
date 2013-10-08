class User < ActiveRecord::Base
	include GeoSearch
	has_many :positions
	before_create :first_session_token
	scope :find_by_email, ->(email){where(email: email).first}
	validates :email, :uniqueness => true
	has_secure_password

	def first_session_token
		self.session_token = SecureRandom.uuid.gsub("-","")
	end

	def set_new_locations(params)
		Position.create(user_id: self.id, latitude: self.last_latitude_position, longitud: self.last_longitude_position)
		last_latitude_position = params[:latitude]
		last_longitude_position = params[:longitude]
		self.save
	end

	def self.find_and_authenticate(email,password)
		user = find_by_email(email)
		if user.authenticate(password)
			user.session_token = generate_token
			user.save
		else
			user.errors[:authentication] << "El email o la contraseña son incorrectos"
		end
		return user
	end

	def self.get_arround_alerts(position)
		range = geo_perimeter(position,2)
		results = self.all
		results.select{|result| result.inside_range?(range)}
	end

	def self.get_filtered_alerts(filters)
		results = self.all
		results.select{|result| filters[:status].include?(result.emergency_state)}
	end

	def self.get_filtered_arround_alerts(position, filters)
		range = geo_perimeter(position,2)
		results = self.all
		results.select{|result| result.inside_range?(range) and filters[:status].include?(result.emergency_state)}
	end

	def last_positions
		positions.last_positions.to_a + [Position.new(user_id: self.id, latitude: self.last_latitude_position, longitud: self.last_longitude_position)]
	end
end


