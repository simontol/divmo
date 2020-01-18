class HomeController < ApplicationController
	#before_filter :authenticate_user!
	
	def index
		
	end

	def dashboard #home dashboard for logged in user
		@user = current_user
		# if request.ip == "127.0.0.1"
		# 	@client_ip = "79.50.78.99"
		# 	
		# else
		if session[:location]
			@client_address = session[:location].values
		elsif request.location
			@client_address = request.location.address
		else
			@client_address = "Zanica"
		end
		

		@events_near = Event.near(@client_address, 25)

		@today_events = Event.today
		@this_week_events = Event.this_week
		@this_month_events = Event.this_month
		render :layout => "index"
	end
end
