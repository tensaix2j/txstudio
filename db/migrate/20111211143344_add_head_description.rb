class AddHeadDescription < ActiveRecord::Migration
  def self.up
  	add_column :apps, :head_description, :text
  end

  def self.down
    remove_column :apps, :head_description

  end
end
