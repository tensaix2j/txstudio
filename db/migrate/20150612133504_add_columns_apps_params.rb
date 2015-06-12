class AddColumnsAppsParams < ActiveRecord::Migration
  def up
  	add_column :apps, :seq_id, :integer
  	add_column :apps, :params, :text
  end

  def down
  	remove_column :apps, :seq_id
  	remove_column :apps, :params 
  	
  end
end
