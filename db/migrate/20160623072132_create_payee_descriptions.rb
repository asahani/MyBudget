class CreatePayeeDescriptions < ActiveRecord::Migration
  def change
    create_table :payee_descriptions do |t|
      t.string :description
      t.integer :payee_id

      t.timestamps
    end
  end
end
