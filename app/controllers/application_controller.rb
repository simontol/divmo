class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :resolve_layout

  def logged_in?
    user_signed_in?
  end

  def login_required
    respond_to do |format|
      format.any { warden.authenticate!(:scope => :user) }
    end
  end

  def admin_required
    unless current_user.admin?
      raise "You have to be an Admin to do this!"
    end
  end

  protected
  after_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  ## You can use it in a before_filter like so:
  ## before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  private
  def resolve_layout
    case action_name
    when 'index'
      'index'
    when 'show'
      'show'
    else
      'application'
    end
  end


end
