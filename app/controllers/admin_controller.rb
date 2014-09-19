class AdminController < ApplicationController

	layout 'template'
	before_filter :authorize, :except=> [:login ] 	

	#--------
	def index
		detect_user_agent()
		@apps = App.find(:all)
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
				redirect_to :action=>:index
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
			
			username 	= params[:txtUsername] 
			password 	= params[:txtPassword] 
			auth_token 	= params[:authenticity_token]
 			
 			if session["_csrf_token"] == auth_token
 				
 				users = User.find(:all, :conditions => [ "username = ?" , "admin"] )
 				
 				if username && password
	 				if users.length > 0

	 					admin = users[0]
	 					if Digest::SHA256.hexdigest( password.to_s ) == admin.hashed_password
							session[:user_id] = "admin"
							redirect_to :action=>:index
						else
							@errormsg = "Wrong password."
						end	
					else 
						@errormsg = "No admin yet."	
					end
				end
				
 			else
 				@errormsg = "Forgery detected."
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
