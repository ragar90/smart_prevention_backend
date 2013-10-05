SmartPrevention::Application.routes.draw do
  scope :api do
    scope :users do
      post "/:id/ping" => "users#ping", as: :ping
      put "/:id/report_status/:status" => "users#emergency_status", as: :report_status
    end
  end
end
