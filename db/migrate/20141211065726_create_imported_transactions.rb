class CreateImportedTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :imported_transactions do |t|
      t.string :raw_data
      t.decimal :credit, :precision => 10, :scale => 2
      t.decimal :debit, :precision => 10, :scale => 2
      t.date :txn_date
      t.string :description
      t.string :tags
      t.decimal :balance, :precision => 10, :scale => 2
      t.integer :account_id
      t.integer :payee_id
      t.integer :category_id
      t.integer :budget_id

      t.timestamps
    end
  end
end
