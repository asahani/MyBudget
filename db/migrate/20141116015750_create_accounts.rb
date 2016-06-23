class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.decimal :initial_balance, :default => 0.0, :precision => 10, :scale => 2
      t.decimal :balance, :default => 0.0, :precision => 10, :scale => 2
      t.integer :account_type, :default => 0
      t.boolean :budget_account, :default => true
      t.integer :bsb_number
      t.integer :card_number
      t.integer :username
      t.string  :hint
      t.boolean :is_active, :default => true
      
      t.boolean :is_debit_negetive, :default => true
      t.integer :import_txn_date_col
      t.integer :import_txn_amount_col
      t.integer :import_txn_description_col
      t.integer :import_txn_balance_col
      t.string  :import_txn_date_format

      t.timestamps
    end
  end
end
