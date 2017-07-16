class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.string :description
      t.decimal :amount, :default => 0.00, :precision => 10, :scale => 2
      t.boolean :weekly, :default => false
      t.boolean :fortnightly, :default => false
      t.boolean :monthly, :default => true
      t.integer :account_id
      t.boolean :is_active, :default => true

      t.timestamps
    end
  end
end
