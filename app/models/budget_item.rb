class BudgetItem < ActiveRecord::Base
  belongs_to :budget
  belongs_to :category
  has_many :budget_transactions

  after_create :update_spend_and_balance

  scope :for_year, -> (year) { joins(:budget).where('budgets.year = ?', year) }

  def update_spend_and_balance
    total_spend = 0
    self.budget_transactions.each do |txn|
      if !txn.debit.nil? && txn.debit > 0
        total_spend += txn.debit
      elsif !txn.credit.nil? && txn.credit > 0
        total_spend -= txn.credit
      end
    end
    self.expenses = total_spend
    self.balance = self.budgeted_amount - self.expenses
    self.save!
  end
end
