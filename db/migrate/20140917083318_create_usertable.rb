class CreateUsertable < ActiveRecord::Migration
  def up
  	
  	create_table :users do |t|

    	t.column :username, 		     :string
    	t.column :hashed_password, 	 :string
		  t.column :role, 			       :string
		  t.column :registered, 		   :string
      
    end
	
  end

  def down
  	 drop_table :users
  end
end
