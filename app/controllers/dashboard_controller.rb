class DashboardController < ApplicationController

	layout 'template'
	before_filter :authorize, :except=> [:index, :login, :app   ] 	

	


	#------------
	def index

		detect_user_agent() 
		@apps = App.find(:all)
		@host = request.host
		@host_with_port = request.host_with_port
		
		respond_to do |format|
			
			format.html { 
			}
			format.rss { 
				
			}
		    format.atom {
		    	@apps.each { |app|
		    		app["pubdate"] = getRubyTimeObj( app.date )
		    		app["url"] = "http://#{ @host_with_port }/dashboard/app/#{  URI::encode( app.name ) }"
		    	}	
		    }
		end

	end

	

	#------------
	def app

		detect_user_agent() 
		app_name = params[:id] ? CGI::unescape( params[:id] ) :""
		apps = App.find(:all, :conditions => [ "name = ?" , app_name ] )
		
		if apps.length > 0 
			@app = apps[0]
			@app.date = getRubyTimeObj(@app.date).strftime("%a, %B %d,%Y %H:%M:%S") if @app.date != nil

		else
			redirect_to "/error/not_found"

		end

	end

	#-----------
	def edit
		detect_user_agent()
		app_name = params[:id] ? CGI::unescape( params[:id] ) :""
		apps = App.find(:all, :conditions => [ "name = ?" , app_name ] )
		
		if apps.length > 0 
			@app = apps[0]
			
		else
			redirect_to :action=>:app
		end
	end
	
	#--------------
	def save
		detect_user_agent()
		app_name = params[:id] ? CGI::unescape( params[:id] ) :""
		app_icon = params[:txtAppIcon] ? CGI::unescape( params[:txtAppIcon] ) :""
		app_desc = params[:txtAppDesc] ? CGI::unescape( params[:txtAppDesc] ) :""
		app_large_icon = params[:txtAppLargeIcon] ? CGI::unescape( params[:txtAppLargeIcon] ) :""
		app_head_desc = params[:txtAppHeadDesc] ? CGI::unescape( params[:txtAppHeadDesc] ) :""
		
		apps = App.find(:all, :conditions => [ "name = ?" , app_name ] )
		
		if apps.length > 0 
			@app = apps[0]
			@app.icon = app_icon
			@app.large_icon = app_large_icon
			@app.description = app_desc
			@app.date = Time.new().strftime("%Y%m%d.%H%M%S") if @app.date == nil
			@app.head_description = app_head_desc
				
			if @app.save()
				redirect_to :action=>:app , :id=>app_name 
			end
		end
		
		
	end
	#-------------
	def add
		detect_user_agent()
		app_name = params[:txtAppName] ? CGI::unescape( params[:txtAppName] ) :""
		app_icon = params[:txtAppIcon] ? CGI::unescape( params[:txtAppIcon] ) :""
		app_large_icon = params[:txtAppLargeIcon] ? CGI::unescape( params[:txtAppLargeIcon] ) :""
		app_desc = params[:txtAppDesc] ? CGI::unescape( params[:txtAppDesc] ) :""
		app_head_desc = params[:txtAppHeadDesc] ? CGI::unescape( params[:txtAppHeadDesc] ) :""
		
		
		@app = App.new()
				
		if app_name != "" && app_icon != "" && app_desc != "" 
		
			apps = App.find(:all, :conditions => [ "name = ?" , app_name ] )
			if apps.length == 0
				@app.name = app_name
				@app.icon = app_icon
				@app.large_icon = app_large_icon
				@app.description = app_desc
				@app.date = Time.new().strftime("%Y%m%d.%H%M%S")
				@app.head_description = app_head_desc
				
				if @app.save()
					redirect_to :action=>:app , :id=>app_name 
				end
			end 
		end
	end

	#-------------
	def delete
		detect_user_agent()
		app_name = params[:id] ? CGI::unescape( params[:id] ) :""
		
		apps = App.find(:all, :conditions => [ "name = ?" , app_name ] )
		
		if apps.length > 0 
			App.delete(apps[0])
			redirect_to :action=>:index
		end
	end

	#----------
	def login
		detect_user_agent()
		if session[:user_id] 
			redirect_to :action=>:index 
		else	
			username = params[:txtUsername] ? CGI::unescape( params[:txtUsername] ) :""
			password = params[:txtPassword] ? CGI::unescape( params[:txtPassword] ) :""
			auth_token = params[:authenticity_token]
			
			if auth_token
				printf "Auth Token: %s\n\n",auth_token
				if username == "admin" && password == "jj1234" 
					session[:user_id] = "admin"
					redirect_to :action=>:index
				else
					@errormsg = "Invalid Username/Password"
				end
			else
				@errormsg = ""
			end
			
		end
	end

	#---------
	def logout
		session[:user_id] = nil
		redirect_to :action=>:index
	end

	def authorize
		if !session[:user_id] 
			redirect_to :action=>:login
		end 
 	end
end





