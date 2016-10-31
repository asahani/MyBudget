class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :active, :default => true
      t.decimal :budget_amount, :precision => 10, :scale => 2
      t.integer :master_category_id
      t.boolean :mandatory, :default => false
      t.boolean :budgeted, :default => false
      t.boolean :miscellaneous, :default => false
      t.boolean :savings, :default => false
      t.boolean :direct_debit, :default => false
      t.boolean :scheduled, :default => false
      t.integer :scheduled_day
      t.boolean :has_template_transaction, :default => false
      t.integer :account_id
      t.integer :payee_id

      t.timestamps
    end
  end
end
