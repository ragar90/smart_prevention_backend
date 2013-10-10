class Api::UsersController < ApplicationController
  #include ApiAuthentication
  #before_action :authenticate_api
  before_action :set_user, except: [:sign_up, :log_in, :help]

  def sign_up
    @user = User.new(user_params)
    if @user.save      
      respond_to do |format|
        format.json{render json:@user}
      end
    else
      respond_to do |format|
        format.json{render json:{errors: @user.errors}}
      end
    end
  end

  def log_in
    @user = User.find_and_authenticate(params[:email], params[:password])
    respond_to do |format|
      format.json{render json:@user}
    end
  end

  def log_out
    @user.session_token = nil
    @user.save
    render json: {message: "Te has desconectado, vuelve pronto"}
  end

  def ping
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
  	@user.emergency_state = params[:status]
  	if @user.valid?
     @user.save
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
    respond_to do |format|
      format.json{render json: {results: @results}}
    end
  end

  def edit
    respond_to do |format|
      format.json{render @user}
    end
  end

  def update
    if @user.update_attributes(user_params)
      respond_to do |format|
        format.json{render json: @user}
      end
    else
      respond_to do |format|
        format.json{ render json: @user.errors}
      end
    end
  end

  def last_positions
    @positions = @user.last_positions
    respond_to do |format|
      format.json{render json: {results: @positions}}
    end
  end

  private

  def set_user
    @user = User.where(id: params[:id]).first
  end

  def user_params
    params[:user].permit!
  end
end
