class UsersController < ApplicationController
  def sign_up
    @user = User.new
    @user.email = params[:user][:email]
    @user.username = params[:user][:username]
    @user.password = params[:user][:password]
    pd = ParseData.new
    user_response = pd.parse_create_user(params[:user].permit!)
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
    pd = ParseData.new
    user_response = pd.parse_login_user(params[:username],params[:password]) 
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
  	@user = User.where(parse_id:params[:parse_id]).first
  	if @user.valid?
      @user.set_new_locations(params[:location])
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
  	@user = User.where(parse_id:params[:parse_id])
  	@user.emergency_state = params[:status]
  	if @user.valid?
     @user.update_to_parse
  	 respond_to do |format|
  			format.json{ render json:{status: :saved}}
  		end
  	else
  		respond_to do |format|
  			format.json{ render json:{status: :failed, errors: @user.errors }}
  		end
  	end
  end

  def help
    if params[:position] and params[:filters]
      @results = User.get_filtered_arround_alerts(params[:position], params[:filters])
    elsif params[:position]
      @results = User.get_arround_alerts(params[:position])
    elsif params[:filters]
      @results = User.get_filtered_alerts(params[:filters])
    else
      @results = User.get_all_users
    end
  end

  def edit
    @user = User.where(parse_id: params[:parse_id]).first
    respond_to do |format|
      format.json{render @user}
    end
  end

  def update
    @user = User.where(parse_id: params[:parse_id]).first
    if @user.update_attributes(params[:user].permit!)
      @user.update_to_parse
      respond_to do |format|
        format.json{render json: @user}
      end
    else
      respond_to do |format|
        format.json{ render json: @user.errors}
      end
    end
  end
end
