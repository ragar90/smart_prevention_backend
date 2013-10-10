config = ActiveRecord::Base.remove_connection

pid = fork do
	ActiveRecord::Base.establish_connection(config)

	while true
		rec = SmsMod::PingReceiver.new
		rec.receive_pings_from_users
		sleep 5
	end
end

ActiveRecord::Base.establish_connection(config)

puts "PID of sms_ping_receiver.rb: #{pid}"