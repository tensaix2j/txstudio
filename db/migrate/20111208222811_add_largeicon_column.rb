class AddLargeiconColumn < ActiveRecord::Migration
  def self.up
  	add_column :apps, :large_icon, :varchar
  end

  def self.down
    remove_column :apps, :large_icon
  end
end
