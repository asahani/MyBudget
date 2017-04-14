class AddHouseAndShareIdToAccountTransaction < ActiveRecord::Migration
  def self.up
    add_column :account_transactions, :house_id, :integer
    add_column :account_transactions, :share_id, :integer
  end

  def self.down
    remove_column :account_transactions, :share_id
    remove_column :account_transactions, :house_id
  end
end
