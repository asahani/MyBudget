class AddTransactionTypeToBudgetTransaction < ActiveRecord::Migration[5.1]
  def self.up
    add_column :budget_transactions, :account_transfer, :boolean, default: false
    add_column :budget_transactions, :loan, :boolean, default: false
    add_column :budget_transactions, :share, :boolean, default: false
    add_column :budget_transactions, :house, :boolean, default: false
    add_column :budget_transactions, :superannuation, :boolean, default: false
  end

  def self.down
    remove_column :budget_transactions, :account_transfer
    remove_column :budget_transactions, :loan
    remove_column :budget_transactions, :share
    remove_column :budget_transactions, :house
    remove_column :budget_transactions, :superannuation
  end
end
