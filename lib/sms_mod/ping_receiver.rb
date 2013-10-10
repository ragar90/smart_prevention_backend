module SmsMod
	class PingReceiver
		attr_reader :client
		def initialize
			@client = Twilio::REST::Client.new TWILIO_ASID, TWILIO_ATOK
		end

		def receive_pings_from_users
			puts "Getting last 5 seconds sms's"
			messages = @client.account.sms.messages.list.select{|sms| sms.from!="+14043342471" and DateTime.parse(sms.date_sent) > 10.minutes.ago}
			messages.each do |sms|
				hash = JSON.parse(sms.body)
				unless hash["id"].nil?
					user = User.where(id:hash["id"]).first
					user.set_new_locations(hash)
				else
					user = User.where(phone_number:hash["phone_number"]).first
					user.set_new_locations(hash)
				end
			end
			puts "Done!! :)"
		end
	end
end
