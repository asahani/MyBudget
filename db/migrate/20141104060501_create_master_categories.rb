class CreateMasterCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :master_categories do |t|
      t.string :name
      t.boolean :display, :default => true

      t.timestamps
    end
  end
end
