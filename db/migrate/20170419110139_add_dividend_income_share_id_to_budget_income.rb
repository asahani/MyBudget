class AddDividendIncomeShareIdToBudgetIncome < ActiveRecord::Migration
  def self.up
    add_column :budget_incomes, :dividend_income_share_id, :integer
  end

  def self.down
    remove_column :budget_incomes, :dividend_income_share_id
  end
end
