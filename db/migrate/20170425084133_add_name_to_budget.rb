class AddNameToBudget < ActiveRecord::Migration[4.2]
  def self.up
    add_column :budgets, :name, :string
  end

  def self.down
    remove_column :budgets, :name
  end
end
