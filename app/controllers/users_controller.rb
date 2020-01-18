class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :follow, :unfollow, :finish_signup]
  before_filter :store_location
	before_filter :authenticate_user!
	#before_filter :admin_required, :except => [:index, :show, :follow, :unfollow]
  before_filter :check_permissions, :only => [:edit, :update, :destroy]
  respond_to :html, :xml, :json, :js

# GET /users
  # GET /users.json
  def index
    @users = User.all.page params[:page]
    respond_with(@users)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_with(@user)
  end
  
    # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_with(@user)
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.save
    flash[:notice] = "User successfully created." if @user.save
    respond_with(@user)
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_geolocation
    session[:location] = {:latitude=> params[:latitude], :longitude=> params[:longitude]}
    respond_to do |format|
      format.json { head :ok }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
  
  def follow
    @user = User.find(params[:id])
    current_user.add_friend(@user)
    
    respond_to do |format|
    format.html { redirect_to(@user, :notice => 'Yuo\'re now following') }
    format.xml  { head :ok }
    format.js
    end
  end
  
  def unfollow
    @user = User.find(params[:id])
    current_user.remove_friend(@user)
    
    respond_to do |format|
    format.html { redirect_to(@user, :notice => 'Yuo\'re NOT following') }
    format.xml  { head :ok }
    format.js
    end
    
  end

   # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end


  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :username, :email, :first_name, :last_name, :gender, :picture, :bio, :website, :birthdate, :hometown, :interests ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end

    def check_permissions
    @user = User.find(params[:id])

      if @user.nil?
        redirect_to users_path
      elsif current_user != @user
        flash[:error] = "You don\'t have permission to take this action"
        redirect_to user_path(@user)
      end
    end

end


