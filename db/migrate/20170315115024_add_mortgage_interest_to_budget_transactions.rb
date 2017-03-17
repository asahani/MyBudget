class AddMortgageInterestToBudgetTransactions < ActiveRecord::Migration
  def self.up
    add_column :budget_transactions, :mortgage_interest, :decimal, default: 0.0, :precision => 10, :scale => 2
    add_column :budget_transactions, :mortgage_principal, :decimal, default: 0.0, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :budget_transactions, :mortgage_interest
    remove_column :budget_transactions, :mortgage_principal
  end
end
