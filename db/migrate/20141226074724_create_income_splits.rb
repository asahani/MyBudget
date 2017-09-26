class CreateIncomeSplits < ActiveRecord::Migration[4.2]
  def change
    create_table :income_splits do |t|
      t.integer :budget_id
      t.integer :income_id
      t.date :income_split_date
      t.decimal :amount, :precision => 10, :scale => 2
      t.decimal :total_received, :precision => 10, :scale => 2
      t.boolean :is_last_for_month, :default => false
      t.timestamps
    end
  end
end
