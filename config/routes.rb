SmartPrevention::Application.routes.draw do
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