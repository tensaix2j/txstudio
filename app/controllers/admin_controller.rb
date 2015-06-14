class AdminController < ApplicationController

	layout 'template'
	before_filter :authorize, :except=> [:login ] 	
	skip_before_filter  :verify_authenticity_token
	

	#--------
	def index
		app_common()
		@apps = App.find(:all , :order => "seq_id" )
		@apps.each { |app|
			
			app.date = timestring_to_timeobj( app.date ).strftime("%Y %B, %d %H:%M:%S")
			
		}
	end


	#-----------
	def edit

		app_common()
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
		app_common()
		
		app_name 		= params[:txtAppName] ? CGI::unescape( params[:txtAppName] ) 		:""
		app_icon 		= params[:txtAppIcon] ? CGI::unescape( params[:txtAppIcon] ) 		:""
		head_desc 		= params[:txtHeadDesc] ? CGI::unescape( params[:txtHeadDesc] )	:""
		app_large_icon 	= params[:txtAppLargeIcon] ? CGI::unescape( params[:txtAppLargeIcon] ) :""
		
		app_head_desc 	= params[:txtAppHeadDesc] 
		app_desc 		= params[:txtAppDesc]
		
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
				flash[:danger]  = "#{ @app.errors.full_messages }"
			end
			
		end

		redirect_to :action=>:edit , :id=> params[:id]

			
		
	end
	

	#------------
	def add
		app_common()
		

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
		
		app_head_desc 	= params[:txtAppHeadDesc] 
		app_desc 		= params[:txtAppDesc] 
		

		@app = App.new()
		@app.name = app_name
		@app.icon = app_icon
		@app.large_icon = app_large_icon
		@app.description = app_desc
		@app.date = Time.new().strftime("%Y%m%d.%H%M%S")
		@app.head_description = app_head_desc

		if @app.save()
		
			flash[:success] = "Added."
	 		redirect_to :action=>:edit , :id=> @app.id

	 	else 
	 		
	 		flash[:danger]  = "#{ @app.errors.full_messages }"
	 		redirect_to :action=>:add

	 	end

	end

	#-------------
	def delete
		
		@app = App.find_by_id( params[:id] )
		if @app 
			App.delete(@app)
		end
		redirect_to :action=>:index
	end

	#----------
	def login

		app_common()
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
							flash[:danger] = "Wrong password."
						end	
					else 
						flash[:danger]  = "No admin yet."	
					end
				end
				
 			
 			end
 				
			
		end
	end

	#---------
	def logout
		session[:user_id] = nil
		redirect_to :controller=>:dashboard, :action=>:index
	end

	#---------------
	def authorize
		if !session[:user_id] 
			redirect_to :action=>:login
		end 
 	end

 	#--------
 	def site

		app_common()
		@sites = Site.find(:all )
	
	end

	#------------
	def addsite
		app_common()
		

		@site = Site.new()
		@site.title 		= "Untitled"
		@site.description 	= ""
		@site.favicon 		= "/imgs/bluecap_32.png"
			
		
	end

	#----------
	def editsite
		app_common()
		site_id = params[:id]
		if site_id
			@site = Site.find_by_id(site_id)
		else
			redirect_to :action => :site
		end	
	end


	#-------
	def saveaddsite

		site_title 			= params[:txt_title] ? CGI::unescape( params[:txt_title] ) :""
		site_description 	= params[:txt_description] ? CGI::unescape( params[:txt_description] ) :""
		site_favicon 		= params[:txt_favicon] ? CGI::unescape( params[:txt_favicon] ) :""
		site_cusom_css 		= params[:txt_custom_css] 
		site_footer 		= params[:txt_footer] 
		site_analytics		= params[:txt_analytics]
		site_commentsystem	= params[:txt_commentsystem] 

		@site = Site.new()
		@site.title = site_title
		@site.description = site_description
		@site_favicon = site_favicon
		@site.custom_css = site_cusom_css
		@site.footer = site_footer
		@site.analytics = site_analytics
		@site.commentsystem = site_commentsystem


		if @site.save()
		
			flash[:success] = "Added."
	 		redirect_to :action=>:editsite , :id=> @site.id

	 	else 
	 		
	 		flash[:danger]  = "#{ @site.errors.full_messages }"
	 		redirect_to :action=>:addsite

	 	end
	end

	#--------------
	def saveeditsite

		app_common()
		
		site_title 			= params[:txt_title] ? CGI::unescape( params[:txt_title] ) :""
		site_description 	= params[:txt_description] ? CGI::unescape( params[:txt_description] ) :""
		site_favicon 		= params[:txt_favicon] ? CGI::unescape( params[:txt_favicon] ) :""
		site_cusom_css 		= params[:txt_custom_css] 
		site_footer 		= params[:txt_footer] 
		site_analytics		= params[:txt_analytics] 
		site_commentsystem	= params[:txt_commentsystem]

		
		@site = Site.find_by_id( params[:id] )
		
		if @site 
			
			@site.title 		= site_title
			@site.description 	= site_description
			@site.favicon 		= site_favicon
			@site.custom_css 	= site_cusom_css
			@site.footer 		= site_footer
			@site.analytics 	= site_analytics
			@site.commentsystem = site_commentsystem
				
			if @site.save()
				flash[:success] = "Saved."
			else
				flash[:danger]  = "#{ @site.errors.full_messages }"
			end
			
		end

		redirect_to :action=>:editsite , :id=> params[:id]

	end

	#-------------
	def deletesite
		
		@site = Site.find_by_id( params[:id] )
		if @site 
			Site.delete(@site)
		end
		redirect_to :action=>:site
	end


end


