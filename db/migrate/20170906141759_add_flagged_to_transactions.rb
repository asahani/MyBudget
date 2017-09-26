class AddFlaggedToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_transactions, :flagged, :boolean, :default => false
    add_column :account_transactions, :flagged, :boolean, :default => false
    add_column :imported_transactions, :flagged, :boolean, :default => false
  end
end
