class UsersController < ApplicationController
  def sign_up
    @user = User.new(params[:user])
    user_response = parse_create_user(params[:user])
    if user_response["sessionToken"] and user_response["objectId"]
      @user.parse_id = user_response["objectId"]
      @user.session_token = user_response["sessionToken"]
      @user.save
      respond_to do |format|
        format.json{render json:@user}
      end
    else
      respond_to do |format|
        format.json{render json: user_response}
      end
    end
  end

  def log_in
    user_response = parse_login_user(params[:username],params[:passwd]) 
    if user_response["sessionToken"] and user_response["objectId"]
      @user = User.where(parse_id:user_response["objectId"] ).first
      @user.session_token = user_response["sessionToken"]
      @user.save
      respond_to do |format|
        format.json{render json:@user}
      end
    else
      respond_to do |format|
        format.json{render json:user_response}
      end
    end
  end


  def ping
  	@user = User.where(id:params[:id])
  	if @user.set_new_locations(params[:location])
  		respond_to do |format|
  			format.json{ render json:{status: :saved}}
  		end
  	else
  		respond_to do |format|
  			format.json{ render json:{status: :failed, errors: @user.errors }}
  		end
  	end
  end

  def emergency_status
  	@user = User.where(id:params[:id])
  	@user.emergency_state = params[:emergency_state]
  	if @user.save
  	respond_to do |format|
  			format.json{ render json:{status: :saved}}
  		end
  	else
  		respond_to do |format|
  			format.json{ render json:{status: :failed, errors: @user.errors }}
  		end
  	end
  end
end
