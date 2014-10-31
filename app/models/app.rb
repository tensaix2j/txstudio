class App < ActiveRecord::Base
	validates_presence_of :name
	validates_uniqueness_of :name

	validates_presence_of :icon
	validates_presence_of :description
	
			
end
