module ApplicationHelper
	def title(page_title)
    content_for(:title) { page_title + " - Divertissimo" }
  end

  def smart_time(datetime)
     if datetime.year == Time.now.year
      I18n.l datetime , :format => :smart
    # elsif datetime.month == Time.now.month
    #   I18n.l datetime , :format => :smart_month
    else
      I18n.l datetime, :format => :smart_year
    end
  end

  def smart_date(start_time,end_time)
    # only returns hours if start day == end day
    if start_time.to_date == end_time.to_date
      return I18n.l end_time , :format => :smart_time
    else
      return smart_time(end_time)
    end
  end

  def tab(value)
    if current_page?(value)
      return :class => 'active'
    end
  end

  def render_events(events)
    render_tag(events, :event, 'events/event', 'Nessun evento')
  end

  def render_groups(groups)
    render_tag(groups, :group, 'groups/group', 'Nessun gruppo')
  end

  def render_members(members)
    render_tag(members, :member, 'shared/member', 'Nessun utente')
  end

  def render_followers(followers)
    render_tag(followers, :follower, 'shared/follower', 'Nessun utente')
  end

  def yield_content!(content_key)
    view_flow.content.delete(content_key)
  end

  def render_tag(collection, as, partial, message)
    if !collection.empty?
      return render :partial => partial , :as => as, :collection => collection
    else
      return raw "<p>"+message+"</p>"
    end
  end

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
