class AddIsClosedToBudget < ActiveRecord::Migration[4.2]
  def self.up
    add_column :budgets, :is_closed, :boolean, :default => false
  end

  def self.down
    remove_column :budgets, :is_closed
  end
end
