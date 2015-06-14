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

	#----------------
	def get_site_setting()

		siteconfig = YAML.load_file( "#{Rails.root}/config/site.yml")
		
		@template_site = Site.find_by_id( siteconfig["id"].to_i )
		@template_site = Site.first() if @template_site == nil
		@template_site = Site.new()   if @template_site == nil
		
	end

	#----------
	def app_common() 

		detect_user_agent()
		get_site_setting()

	end





end
