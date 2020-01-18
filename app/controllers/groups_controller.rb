class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :follow, :unfollow]
  before_filter :login_required, :except => [:index, :show, :venues, :artists] 
  before_filter :check_permissions, :only => [:edit, :update, :destroy]
  before_filter :admin_required , :only => [:destroy]
  respond_to :html, :js, :xml, :json
  
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all.page params[:page]
    respond_with(@groups)
  end

  def venues
    @groups = Group.where( type: "Venue" ).page params[:page]
    render :index, layout: "index"
  end

  def artists
    @groups = Group.where( type: "Artist" ).page params[:page]
    render :index, layout: "index"
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @followers = @group.members  
    respond_with(@group)
  end
  
  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new
    respond_with(@group)
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.owner = current_user    
    @group.status = "active" 
    @group.save
    flash[:notice] = 'Group was successfully created.' if @group.save
    respond_with(@group)
  end

  def update
    @group.update(group_params)
    flash[:notice] = "Group was successfully updated." if @group.update
    respond_with(@group)
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_with(@group)
  end
  
  def follow
    current_user.join!(@group)
    #flash[:notice] = 'Yuo are now following'
    respond_with(@group)
  end
  
  def unfollow
    current_user.leave(@group)
    #flash[:notice] = 'Yuo are not following'
    respond_with(@group)
  end
  
private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :picture, :description, :type, :category, :privacy, :website, :link, :likes, :checkins, :owner_id, :status, :address, :coordinates)
    end
  
  def check_permissions
    @group = Group.find(params[:id])

    if @group.nil?
      redirect_to groups_path
    elsif !current_user.owner_of?(@group)
      flash[:error] = "You don\'t have permission to take this action"
      redirect_to group_path(@group)
    end
  end

end
