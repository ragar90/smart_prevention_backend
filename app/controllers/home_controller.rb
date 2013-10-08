class HomeController < ApplicationController
  def index
  end

  def alerts
    @results = User.get_all_users.map{|u|{name: u.name, status: u.emergency_state, latitude: u.latitude_position, longitude: u.longitude_position}}
  end

  def rescues
  end

  def notifications
  end
end
