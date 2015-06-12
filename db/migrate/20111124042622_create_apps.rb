class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|

      t.column :name,                :string
      t.column :head_description,    :text
      t.column :description,         :text
      t.column :date,                :string
      t.column :icon,                :string
      t.column :large_icon,          :string
      	
    end
  end

  def self.down
    drop_table :apps
  end
end

