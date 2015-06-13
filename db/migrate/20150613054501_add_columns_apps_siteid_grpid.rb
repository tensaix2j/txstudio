class AddColumnsAppsSiteidGrpid < ActiveRecord::Migration
  def up
  	add_column :apps, :site_id,  :integer
  	add_column :apps, :group_id, :integer
  end

  def down
  	remove_column :apps, :site_id
  	remove_column :apps, :group_id
  end
end

