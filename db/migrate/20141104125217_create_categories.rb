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
      
      t.timestamps
    end
  end
end
