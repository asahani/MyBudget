class CreateBudgetTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :budget_transactions do |t|
      t.integer :account_id
      t.integer :budget_item_id
      t.integer :payee_id
      t.integer :budget_id
      t.integer :category_id
      t.decimal :credit, :default => 0.00, :precision => 10, :scale => 2
      t.decimal :debit, :default => 0.00, :precision => 10, :scale => 2
      t.date    :transaction_date
      t.text    :comments
      t.string  :raw_data
      t.boolean :manual, :default => true
      t.boolean :scheduled, :default => false
      t.boolean :budgeted, :default => false
      t.boolean :miscellaneous, :default => true
      t.boolean :savings, :default => false
      t.boolean :reconciled, :default => false

      t.timestamps
    end
  end
end
