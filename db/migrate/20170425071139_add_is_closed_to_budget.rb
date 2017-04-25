class AddIsClosedToBudget < ActiveRecord::Migration
  def self.up
    add_column :budgets, :is_closed, :boolean, :default => false
  end

  def self.down
    remove_column :budgets, :is_closed
  end
end
