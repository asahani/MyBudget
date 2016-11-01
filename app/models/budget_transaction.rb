class BudgetTransaction < ActiveRecord::Base
  attr_accessor :transaction_type
  ##################################
  # Relationships
  ##################################
  belongs_to :account
  belongs_to :budget
  belongs_to :budget_item
  belongs_to :payee
  belongs_to :category

  ##################################
  # Validations
  ##################################
  validates_presence_of :account_id,:payee_id, :category_id
  validates_numericality_of :payee_id, :account_id
  validates_numericality_of :credit, :debit, :allow_nil => true

  ##################################
  # Callbacks
  ##################################
  after_create :update_budget_item, :update_budget_account, :update_account_payee
  after_update :update_budget_item, :update_budget_account, :update_account_payee
  after_destroy :update_budget_item, :update_budget_account, :update_account_payee


  ##################################
  # Scoped Methods
  ##################################
  scope :miscellaneous_transactions, -> { where(miscellaneous: true)}
  scope :savings_transactions, -> { where('savings = ? && credit > ?',true,0)}
  scope :savings_expense_transactions, -> { where('savings = ? && debit > ?',true,0)}
  scope :reconciled_transactions, -> { where('reconciled = ?',true)}
  scope :nonconciled_transactions, -> { where('reconciled = ?',false)}

  ##################################
  # Class Methods
  ##################################

  def self.total_miscellaneous_grouped_by_master_category(budget_id)
    txns = where(budget_id: budget_id)
    txns = txns.miscellaneous_transactions
    txns = txns.joins(:category)
    txns = txns.group("categories.name")
    txns = txns.select("categories.name as name, sum(debit) as total_expense")
    txns = txns.order("total_expense DESC").first(10)
    # txns.group_by { |t| t.category.name}
  end

  private
  def update_budget_item
    if self.budgeted && !self.budget_item.nil?
      self.budget_item.update_spend_and_balance
    elsif self.miscellaneous
      self.budget_item.update_spend_and_balance
    end
  end

  def update_budget_account
    # Loop through all budget_accounts for self.account and update the balance
    budget_account = BudgetAccount.find_by_budget_id_and_account_id(self.budget.id, self.account.id)
    unless budget_account.nil?
      budget_account.update_balance
      budget_account.update_future_budget_accounts
    end
  end

  def update_account_payee
    if self.payee.is_account
      puts 'payee is account'
      budget_account = BudgetAccount.find_by_budget_id_and_account_id(self.budget.id, self.payee.account.id)
      unless budget_account.nil?
        budget_account.update_balance
        budget_account.update_future_budget_accounts
      end
    end
  end
end
