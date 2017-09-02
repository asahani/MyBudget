class BudgetAccount < ApplicationRecord
  ##################################
  # Relationships
  ##################################
  belongs_to :budget
  belongs_to :account

  ##################################
  # Validations
  ##################################
  validates_presence_of :account_id, :budget_id
  validates_numericality_of :account_id, :budget_id, :balance

  ##################################
  # Callbacks
  ##################################
  after_create :set_opening_balance

  ##################################
  # Scoped Methods
  ##################################
  scope :transaction_account, -> { joins(account: :account_type).where('account_types.name = ?', "Transaction") }

  ##################################
  # Class Methods
  ##################################

  ##################################
  # Get Methods
  ##################################

  def get_progress_percentage
    progress = 1
    self.paid ? progress = progress + 33 : progress
    self.reconciled ? progress = progress + 33 : progress
    self.documented ? progress = progress + 33 : progress

    return progress
  end

  ##################################
  # Update Methods
  ##################################
  def update_balance
    total_spend = 0
    txns = BudgetTransaction.where('budget_id = ? and account_id = ?',self.budget.id, self.account.id)

    txns.each do |txn|
      if !txn.debit.nil? && txn.debit > 0
        total_spend -= txn.debit
      elsif !txn.credit.nil? && txn.credit > 0
        total_spend += txn.credit
      end
    end

    self.balance = total_spend
    self.update_withdrawal_balance
    self.save!
  end

  def update_withdrawal_balance
    txns = BudgetTransaction.where('budget_id = ? and payee_id = ?',self.budget.id, self.account.payee.id)

    txns.each do |txn|
      self.balance += txn.debit - txn.credit
    end
  end

  def update_future_budget_accounts
    future_budget_accounts = BudgetAccount.joins(:budget).where('budgets.start_date > ? AND account_id = ?',self.budget.start_date,self.account.id).order('budgets.start_date')
    prev_month_closing_balance = self.opening_balance + self.balance

    future_budget_accounts.each do |budget_account|
      budget_account.opening_balance = prev_month_closing_balance
      budget_account.save!
      prev_month_closing_balance = budget_account.opening_balance + budget_account.balance
    end

    self.account.balance = prev_month_closing_balance
    self.account.save!
  end

  private

  def set_opening_balance
    prev_budget_account = BudgetAccount.joins(:budget).where('budgets.start_date < ? AND account_id = ?',self.budget.start_date,self.account.id).order('budgets.start_date DESC').first

    unless prev_budget_account.nil?
      self.opening_balance = prev_budget_account.opening_balance + prev_budget_account.balance
    else
      self.opening_balance = self.account.initial_balance
    end

    self.save!
  end

end
