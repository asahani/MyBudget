class AddHouseIdShareIdAndHistoricalToBudgetTransaction < ActiveRecord::Migration[5.1]
  def self.up
    add_column :budget_transactions, :house_id, :integer
    add_column :budget_transactions, :share_id, :integer
    add_column :budget_transactions, :historical, :boolean, default: false
  end

  def self.down
    remove_column :budget_transactions, :share_id
    remove_column :budget_transactions, :house_id
    remove_column :budget_transactions, :historical
  end
end
