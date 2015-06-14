class DashboardController < ApplicationController

	layout 'template'
	
	#------------
	def index

		app_common() 
		@apps = App.find(:all, :order => "seq_id" )
		@host = request.host
		@host_with_port = request.host_with_port
		
		respond_to do |format|
			
			format.html { 
			}
			format.rss { 
				
			}
		    format.atom {
		    	@apps.each { |app|
		    		app["pubdate"] = timestring_to_timeobj( app.date )
		    		app["url"] = "http://#{ @host_with_port }/dashboard/app/#{  URI::encode( app.name ) }"
		    	}	
		    }
		end

	end

	

	#------------
	def app

		app_common() 
		app_name = params[:id] ? CGI::unescape( params[:id] ) :""
		apps = App.find(:all, :conditions => [ "name = ?" , app_name ] )
		
		if apps.length > 0 
			@app = apps[0]
			@app.date = timestring_to_timeobj(@app.date).strftime("%a, %B %d,%Y %H:%M:%S") if @app.date != nil

		else
			redirect_to "/error/not_found"

		end

	end

	
end





