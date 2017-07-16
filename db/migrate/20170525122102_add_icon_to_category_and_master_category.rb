class AddIconToCategoryAndMasterCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :icon, :string
    add_column :master_categories, :icon, :string
  end

  def self.down
    remove_column :master_categories, :icon
    remove_column :categories, :icon
  end
end
