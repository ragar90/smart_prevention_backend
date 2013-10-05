class ZonesController < ApplicationController
  def index
  	@zones = params[:position] ? Zone.arround(params[:position]) : Zone.get_parse_all
  	respond_to do |format|
  		format.json{render json: @zones}
  	end
  end
end
