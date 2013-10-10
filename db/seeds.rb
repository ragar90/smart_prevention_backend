states = [:unknown, :injured,:ok,:damage]
(1..20).each do |i|
	puts i
	state = states.sample
	params = {
						name: "Rene Garcia-#{i}",
						twitter_account: "jhlive90-#{i}",
						facebook_account: "jhlive90-#{i}",
						email: "rene.garciah_#{i}@hotmail.com",
						password: "jhlive_#{i}",
						password_confirmation: "jhlive_#{i}",
						blood_type: "AB-RH+",
						alergies: "none",
						home_addres: "Colonia Universitaria Norte Calle Alirio Cornejo Block H #21",
						emergency_state: state,
						latitude_position: "",
						longitude_position: "",
						medications_taken: "none"
					}
	User.create(params)
end
