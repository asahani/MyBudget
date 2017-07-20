class CreateNetWorths < ActiveRecord::Migration
  def change
    create_table :net_worths do |t|
      t.integer :account_id
      t.integer :share_id
      t.integer :house_id
      t.integer :budget_id
      t.date :capture_date
      t.decimal :value, :default => 0.00

      t.timestamps
    end
    add_index :net_worths, :account_id
    add_index :net_worths, :share_id
    add_index :net_worths, :budget_id
    add_index :net_worths, :house_id
  end
end
