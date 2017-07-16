class AddNameToBudget < ActiveRecord::Migration
  def self.up
    add_column :budgets, :name, :string
  end

  def self.down
    remove_column :budgets, :name
  end
end
