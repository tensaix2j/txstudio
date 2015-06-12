class AdminController < ApplicationController

	layout 'template'
	before_filter :authorize, :except=> [:login ] 	
	skip_before_filter  :verify_authenticity_token


	#--------
	def index
		detect_user_agent()
		@apps = App.find(:all , :order => "seq_id" )
		@apps.each { |app|
			
			app.date = timestring_to_timeobj( app.date ).strftime("%Y %B, %d %H:%M:%S")
			
		}
	end


	#-----------
	def edit

		detect_user_agent()
		app_id = params[:id]
		if app_id
			@app = App.find_by_id(app_id)
		else
			redirect_to :action => :index
		end	
	end
	
	#------------
	def saveseq

		response = {
			:status => 0,
			:statusmsg => "OK"
		}

		begin
			seq_hash = JSON.parse( params[:data] )
			@apps = App.find(:all)
			@apps.each { |app|


				if seq_hash[ app.id.to_s ]
					
					app.seq_id = seq_hash[ app.id.to_s ] 
					app.save()
				end
			}
			
		rescue Exception => e
		 
			response[:status] = "-1"
			response[:statusmsg] = e.to_s
		end


		render :text => response.to_json

	end


	#--------------
	def save
		detect_user_agent()
		
		app_name = params[:txtAppName] ? CGI::unescape( params[:txtAppName] ) 		:""
		app_icon = params[:txtAppIcon] ? CGI::unescape( params[:txtAppIcon] ) 		:""
		head_desc = params[:txtHeadDesc] ? CGI::unescape( params[:txtHeadDesc] )	:""
		app_desc = params[:txtAppDesc] ? CGI::unescape( params[:txtAppDesc] ) 		:""
		app_large_icon = params[:txtAppLargeIcon] ? CGI::unescape( params[:txtAppLargeIcon] ) :""
		app_head_desc = params[:txtAppHeadDesc] ? CGI::unescape( params[:txtAppHeadDesc] ) :""
		
		@app = App.find_by_id( params[:id] )
		
		if @app 
			
			@app.name = app_name
			@app.icon = app_icon
			@app.large_icon = app_large_icon
			@app.description = app_desc
			@app.date = Time.new().strftime("%Y%m%d.%H%M%S") if @app.date == nil
			@app.head_description = head_desc
				
			if @app.save()
				flash[:success] = "Saved."
			else
				flash[:error]  = "#{ @app.errors.full_messages }"
			end
			
		end

		redirect_to :action=>:edit , :id=> params[:id]

			
		
	end
	

	#------------
	def add
		detect_user_agent()
		

		@app = App.new()
		@app.name 			= "Untitled"
		@app.icon 			= "http://icons.iconarchive.com/icons/alecive/flatwoken/96/Apps-Icon-Template-File-B-icon.png"
		@app.large_icon 	= "http://icons.iconarchive.com/icons/alecive/flatwoken/256/Apps-Icon-Template-File-B-icon.png"
		@app.description 	= "Description HTML"
		
	end


	#-------------
	def saveadd
		
		app_name 		= params[:txtAppName] ? CGI::unescape( params[:txtAppName] ) :""
		app_icon 		= params[:txtAppIcon] ? CGI::unescape( params[:txtAppIcon] ) :""
		app_large_icon 	= params[:txtAppLargeIcon] ? CGI::unescape( params[:txtAppLargeIcon] ) :""
		app_desc 		= params[:txtAppDesc] ? CGI::unescape( params[:txtAppDesc] ) :""
		app_head_desc 	= params[:txtAppHeadDesc] ? CGI::unescape( params[:txtAppHeadDesc] ) :""
		
		@app = App.new()
		@app.name = app_name
		@app.icon = app_icon
		@app.large_icon = app_large_icon
		@app.description = app_desc
		@app.date = Time.new().strftime("%Y%m%d.%H%M%S")
		@app.head_description = app_head_desc
		@app.save()
	 
		redirect_to :action=>:index
	end

	#-------------
	def delete
		detect_user_agent()
		
		@app = App.find_by_id( params[:id] )
		if @app 
			App.delete(@app)
		end
		redirect_to :action=>:index
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
