class Account < ApplicationRecord

  ##################################
  # Relationships
  ##################################
  belongs_to :account_type
  has_many :budget_transactions
  has_one :payee
  has_many :goals

  ##################################
  # Validations
  ##################################
  validates_uniqueness_of :name
  validates_presence_of :name, :balance, :account_type_id
  validates_numericality_of :balance

  ##################################
  # Callbacks
  ##################################
  after_create :set_initial_balance_as_balance, :create_account_transfer_payee, :create_budget_account_for_current_budget
  after_update :update_payee_details
  ##################################
  # Scoped Methods
  ##################################
  scope :active, -> { where(is_active: true)}
  scope :for_budget, -> { where(budget_account: true)}
  scope :for_miscellaneous, -> { joins(:account_type).where('account_types.name = ? OR account_types.name = ? OR account_types.name = ?', "Transaction","Savings","Credit") }
  scope :transaction_account, -> { joins(:account_type).where('account_types.name = ?', "Transaction") }
  scope :savings_account, -> { joins(:account_type).where('account_types.name = ?', "Savings") }
  scope :credit_account, -> { joins(:account_type).where('account_types.name = ?', "Credit") }
  scope :loan_account, -> { joins(:account_type).where('account_types.name = ?', "Loan") }
  scope :mortgage_account, -> { joins(:account_type).where('account_types.name = ?', "Mortgage") }
  scope :offset_account, -> { joins(:account_type).where('account_types.name = ?', "Offset") }
  scope :brokerage_account, -> { joins(:account_type).where('account_types.name = ?', "Brokerage") }
  scope :goal_account, -> { joins(:account_type).where('account_types.name = ? OR account_types.name = ?', "Savings","Offset") }
  scope :for_loan, -> { joins(:account_type).where('account_types.name = ? OR account_types.name = ? OR account_types.name = ?', "Transaction","Savings","Offset") }
  scope :for_transfer, -> { joins(:account_type).where('account_types.name = ? OR account_types.name = ? OR account_types.name = ? OR account_types.name = ? OR account_types.name = ?', "Transaction","Savings","Credit","Offset","Brokerage") }
  ##################################
  # Class Methods
  ##################################

  #TODO
  def recalculate_balance
  end

  private

  def set_initial_balance_as_balance
    self.balance = self.initial_balance
    self.save!
  end

  def create_account_transfer_payee
    category = Category.find_by_name("Account Transfer")
    Payee.create!(name: self.name,description: self.name, account_id: self.id, is_account: true, category_id: category.id)
  end

  def create_budget_account_for_current_budget
    if self.budget_account
      budget = Budget.where('start_date <= ? and end_date >= ?',Time.now.to_date,Time.now.to_date).first
      unless budget.nil?
        BudgetAccount.create!(budget_id: budget.id, account_id: self.id, balance: 0.00,opening_balance: self.balance)
      end
    end
  end

  def update_payee_details
    payee = Payee.find_by_account_id(self.id)
    unless payee.nil?
      payee.update_attributes!(name: self.name,description: self.name)
    end
  end
end
