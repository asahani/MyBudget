class CreateBudgetIncomes < ActiveRecord::Migration[4.2]
  def change
    create_table :budget_incomes do |t|
      t.string :description
      t.decimal :amount, :default => 0.00, :precision => 10, :scale => 2
      t.integer :income_id
      t.integer :budget_id
      t.integer :account_id
      t.integer :budget_transaction_id
      t.boolean :credited

      t.timestamps
    end
  end
end
