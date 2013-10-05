class PushNotificationsController < ApplicationController
	before_action :set_parse_data, except: :broadcast_alert
  def alert_disaster
  	session[:alert_type] = :disaster
  	notification = {"channels" =>["emergency"],"data"=>{"alert_type" => "disaster", "alert_message" => "Esta sucediendo un desastre natural en este momentos, favor tomar las medidas de prevencion adecuadas y buscar el alvergue mas cercano"}, "action"=>"emergency_message"}
  	@parse_data.parse_push_notification(notification)
  	redirect_to broadcast_alert_path
  end

  def disaster_finish
  	session[:alert_type] = :disaster_conclude
  	notification = {"channels" =>["emergency"],"data"=>{"alert_type" => "disaster_conclude", "alert_message" => "El desaste ha concluido o pronto concluira, favor marcar su estado fisico y ayudar a las personas cercanas que necesiten ayuda"}, "action"=>"emergency_message"}
  	@parse_data.parse_push_notification(notification)
  	redirect_to broadcast_alert_path
  end

  def normality_restored
  	session[:alert_type] = :normality_restored
  	notification = {"channels" =>["emergency"],"data"=>{"alert_type" => "normality_restored", "alert_message" => "La alerta de desastre ha concluido"}, "action"=>"emergency_message"}
  	@parse_data.parse_push_notification(notification)
  	redirect_to broadcast_alert_path
  end

  def broadcast_alert
  	session[:alert_type] ||= :normality_restored
  	case session[:alert_type]
	  	when :disaster
	  		@post_alert_url = disaster_conclude_path 
	  		@alert_type_style = "red_alert"
	  		@next_image = "sos.png"
	  		@state_label = "Alerta Roja: Estado Crítico"
	  	when :disaster_conclude
	  		@post_alert_url = normality_restored_path
	  		@alert_type_style = "yellow_alert"
	  		@next_image = "ok.png"
	  		@state_label = "Alerta Amarilla: Mantener Precaución"
	  	when :normality_restored
	  		@post_alert_url = disaster_alert_path
	  		@alert_type_style = "green_alert"
	  		@next_image = "danger.png"
	  		@state_label = "Ninguna Alerta: Todo en Normalidad"
  	end
  	render layout:false
  end

  private

  def set_parse_data
  	@parse_data = ParseData.new
  end
end
