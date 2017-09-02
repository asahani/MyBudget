class AddIconToCategoryAndMasterCategory < ActiveRecord::Migration[4.2]
  def self.up
    add_column :categories, :icon, :string
    add_column :master_categories, :icon, :string
  end

  def self.down
    remove_column :master_categories, :icon
    remove_column :categories, :icon
  end
end
