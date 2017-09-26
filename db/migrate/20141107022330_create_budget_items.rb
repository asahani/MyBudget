class CreateBudgetItems < ActiveRecord::Migration[4.2]
  def change
    create_table :budget_items do |t|
      t.integer :budget_id
      t.integer :category_id
      t.decimal :budgeted_amount, :precision => 10, :scale => 2
      t.date    :payment_date
      t.decimal :expenses, :default => 0.0, :precision => 10, :scale => 2
      t.decimal :balance, :default => 0.0, :precision => 10, :scale => 2
      t.text    :comment
      t.boolean :complete, :default => false

      t.timestamps
    end
  end
end
