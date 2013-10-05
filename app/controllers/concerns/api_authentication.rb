module ApiAuthentication
	extend ActiveSupport::Concern
	def authenticate_api
		authenticate_or_request_with_http_token do |token, options|
    	@user = User.where(parse_id: params[:parse_id], session_token:token).first
    	!@user.nil?
  	end
	end
end