class Api::ZonesController < ApplicationController
  #include ApiAuthentication
  #before_action :authenticate_api
  def index
  	@zones = params["position"] ? Zone.arround(params["position"]) : Zone.all
  	respond_to do |format|
  		format.json{render json: @zones}
  	end
  end
end
