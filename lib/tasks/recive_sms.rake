require Rails.root.join('lib', 'sms_mod', 'ping_receiver')
desc "This task is called by the Heroku scheduler add-on"
task :recive_sms => :environment do
  puts "Quering for sms's"
  rec = SmsMod::PingReceiver.new
  rec.receive_pings_from_users
end