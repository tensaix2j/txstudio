# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  	rescue_from ActionController::UnknownAction, :with => :action_not_found


  	def action_not_found
  		render :text => "action_not_found"
	end

	#-------------------
	def timestring_to_timeobj( timestamp )
		
		if timestamp && timestamp != ""

			return Time.parse("%04d/%02d/%02d %02d:%02d:%02d" % timestamp.scan(/(....)(..)(..).(..)(..)(..)/)[0].map { |item| item.to_i } )
		else 
			return nil
		end
	
	end

	#-------------------
	def browser_requirement( browser_req ) 

		browser_req["Internet Explorer"] = "9.0"
		browser_req["Firefox"] = "12.0"
		browser_req["Chrome"] = "15.0"
		browser_req["Opera"] = "10.0"
		browser_req["Safari"] = "4.0"
	
	end

	#--------------
	def detect_user_agent() 

		require 'useragent'
		@user_agent = UserAgent.parse(request.env['HTTP_USER_AGENT'])
		@browser_req = {}
		browser_requirement( @browser_req )

	end




end
