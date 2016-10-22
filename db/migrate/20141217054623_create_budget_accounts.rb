class CreateBudgetAccounts < ActiveRecord::Migration
  def change
    create_table :budget_accounts do |t|
      t.integer :account_id
      t.integer :budget_id
      t.decimal :opening_balance, :default => 0.0, :precision => 10, :scale => 2
      t.decimal :balance, :default => 0.0, :precision => 10, :scale => 2
      
      t.boolean :paid, :default => false
      t.boolean :reconciled, :default => false
      t.boolean :documented, :default => false

      t.timestamps
    end
  end
end
