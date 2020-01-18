class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :attend, :unattend]
  before_filter :login_required, :except => [:index, :show]
  before_filter :check_permissions, :only => [:edit, :update, :destroy]
  respond_to :html, :xml, :json, :js

  def index
    if params[:date]
      case params[:date]
      when "today"
        @events = Event.today
      when "week"
        @events = Event.this_week
      when "month"
        @events = Event.this_month
      when "past"
        @events = Event.past
      end
    else
      @events = Event.future
    end
    @events = @events.page params[:page]
    respond_with(@events)
  end

  def show
    @group = @event.group
    respond_with(@event)
  end

  def new
    @group = Group.find(params[:group_id])
    @event = @group.events.new
    @event.start_time = Time.now
    @event.end_time = Time.now+2.hours
    respond_with(@event)
  end

  def edit
  end

  def create
    @group = Group.find(params[:group_id])
    @event = @group.events.build(event_params)
    @event.creator = current_user
    @event.save
    flash[:notice] = 'Event was successfully created.' if @event.save
    respond_with(@event)
  end

  def update
    @event.update(event_params)
    flash[:notice] = 'Event was successfully updated.' if @event.update
    respond_with(@event)
  end

  def destroy
    @event.destroy
    respond_with(@event)
  end

  def attend
    @event.add_attendee(current_user)
    #flash[:notice] = 'You are attending!' #if @event.add_attendee(current_user)
    respond_with(@event)
  end

  def unattend
    @event.remove_attendee(current_user)
    #flash[:notice] = 'You are not attending!' #if @event.remove_attendee(current_user)
    respond_with(@event)
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :picture, :description, :start_time, :end_time, :privacy, :attendees_count, :address, :coordinates , :group, :group_id )
  end

  def check_permissions
    if @event.nil?
      redirect_to events_path
    elsif !current_user.creator_of?(@event)
      flash[:error] = "You don\'t have permission to take this action"
      redirect_to event_path(@event)
    end
  end

end
