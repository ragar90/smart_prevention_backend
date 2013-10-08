SmartPrevention::Application.routes.draw do
  root :to => "home#index"
  scope :home do
    get "index"=>"home#index"
    get "alerts"=>"home#alerts"
    get "refuges"=>"home#refuges"
    get "rescues"=>"home#rescues"
  end
  
  scope :push_notifications do
    post "alert_disaster" => "push_notifications#alert_disaster", as: :disaster_alert
    post "disaster_finish" => "push_notifications#disaster_finish" , as: :disaster_conclude
    post "normality_restored" => "push_notifications#normality_restored" , as: :normality_restored
  end
  
  get "broadcast"=> "push_notifications#broadcast_alert", as: :broadcast_alert
  
  namespace :api do
    scope :users do
      post "sign_up" => "users#sign_up", as: :sign_up
      post "log_in" => "users#log_in", as: :login
      post ":id/ping" => "users#ping", as: :ping
      put ":id/emergency_status/:status" => "users#emergency_status", as: :report_status
      get ":id/help" =>"users#help", as: :comunity_help
      get ":id/last_positions"=>"users#last_positions", as: :last_positions
    end

    get "zones" => "zones#index", as: :zones
  end

  resources :zones
end