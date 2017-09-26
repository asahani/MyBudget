class CreatePayees < ActiveRecord::Migration[4.2]
  def change
    create_table :payees do |t|
      t.string :name
      t.string :description
      t.integer :category_id
      t.boolean :is_system, :default => false
      t.boolean :is_account, :default => false
      t.integer :account_id

      t.timestamps
    end
  end
end
