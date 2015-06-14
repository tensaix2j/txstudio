class CreateSites < ActiveRecord::Migration

  def self.up

	create_table :sites do |t|

		t.column :title,                :string
		t.column :description,			:text
		t.column :favicon,    			:string
		
		t.column :custom_css,			:text
		t.column :footer,				:text

		t.column :analytics, 			:text
		t.column :commentsystem,		:text
		t.column :params, 				:text
	end
  end

  def self.down
    drop_table :sites
  end
end

