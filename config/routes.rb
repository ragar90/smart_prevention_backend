SmartPrevention::Application.routes.draw do
  root :to => "home#index"
  scope :home do
    get "index"=>"home#index"
    get "alerts"=>"home#alerts"
    get "refuges"=>"home#refuges"
    get "rescues"=>"home#rescues"
  end
  post "push_notifications/alert_disaster", as: :disaster_alert
  post "push_notifications/disaster_finish", as: :disaster_conclude
  post "push_notifications/normality_restored", as: :normality_restored
  get "broadcast"=> "push_notifications#broadcast_alert", as: :broadcast_alert
  
  scope :api do
    scope :users do
      post "/:parse_id/ping" => "users#ping", as: :ping
      put "/:parse_id/emergency_status/:status" => "users#emergency_status", as: :report_status
      post "sign_up" => "users#sign_up", as: :sign_up
      post "log_in" => "users#log_in", as: :login
      get ":parse_id/help" =>"users#help", as: :comunity_help
    end

    get "zones" => "zones#index", as: :zones
  end
end