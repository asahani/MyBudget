class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :name
      t.string :address
      t.integer :mortgage_account_id
      t.integer :offset_account_id
      t.date :purchase_date
      t.float :price_paid
      t.float :original_balance
      t.float :current_value
      t.float :interest_rate
      t.integer :term_length
      t.date :term_start_date

      t.timestamps
    end
  end
end
