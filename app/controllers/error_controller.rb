class ErrorController < ApplicationController

	layout 'template'
	
	def not_found
		detect_user_agent() 
	end
end
