	
	require 'digest/sha2'
	require 'time'

	def main( argv )
		
		if argv.length < 1

			puts "rails runner `pwd`/create_admin.rb <admin password>"

		else
			admin = User.new()
			admin.username = "admin"
			admin.hashed_password = Digest::SHA256.hexdigest( argv[0] )
			admin.role = "admin"
			admin.registered = Time.now().strftime("%Y%m%d.%H%M%S")

			admin.save!

			puts "Admin created!"
		end
	end	

	main ARGV

