class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :name
      t.string :code
      t.string :share_type
      t.decimal :units
      t.decimal :purchase_price
      t.date :purchase_date
      t.decimal :last_price
      t.decimal :sell_price, :default => nil
      t.date :sell_date, :default => nil
      t.integer :brokerage_account_id
      t.boolean :no_cash_transaction, :default => false

      t.timestamps
    end
  end
end
