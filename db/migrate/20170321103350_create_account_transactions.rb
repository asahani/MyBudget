class CreateAccountTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :account_transactions do |t|
      t.integer :account_id
      t.integer :payee_id
      t.integer :budget_id
      t.integer :category_id
      t.decimal :amount, default: 0.0, :precision => 10, :scale => 2
      t.date :transaction_date
      t.string :comments
      t.boolean :reconciled

      t.timestamps
    end
  end
end
