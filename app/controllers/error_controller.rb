class ErrorController < ApplicationController

	layout 'template'
	
	def not_found

		@template_site = App.new()
		[:title,:description,:favicon,:custom_css,:analytics,:footer].each {  |item|
			@template_site[item] = ""
		}
		
		detect_user_agent() 
	end
end
