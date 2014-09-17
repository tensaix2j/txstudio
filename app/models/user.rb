class User < ActiveRecord::Base
	
	validates_presence_of :username
	validates_presence_of :hashed_password
	validates_uniqueness_of :username


end
