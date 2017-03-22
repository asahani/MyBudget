class BudgetTransaction < ActiveRecord::Base
  attr_accessor :transaction_type
  acts_as_taggable
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
  before_save :update_mortgage_account_balance
  after_create :update_budget_item, :update_budget_account, :update_account_payee, :add_category_tag
  after_update :update_budget_item, :update_budget_account, :update_account_payee
  after_destroy :update_budget_item, :update_budget_account, :update_account_payee,:update_mortgage_account_balance


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

  def self.total_miscellaneous_grouped_by_master_category(budget_id,limit=10)
    txns = where(budget_id: budget_id)
    txns = txns.miscellaneous_transactions
    txns = txns.joins(category: :master_category)
    txns = txns.group("master_categories.name")
    txns = txns.select("master_categories.name as name, sum(debit) as total_expense")
    txns = txns.order("total_expense DESC").first(limit)
    # txns.group_by { |t| t.category.name}
  end


  def self.total_miscellaneous_grouped_by_category(budget_id, limit=10)
    txns = where(budget_id: budget_id)
    txns = txns.miscellaneous_transactions
    txns = txns.joins(:category)
    txns = txns.group("categories.name")
    txns = txns.select("categories.name as name, sum(debit) as total_expense")
    txns = txns.order("total_expense DESC").first(limit)
    # txns.group_by { |t| t.category.name}
  end

  def self.total_grouped_by_external_payee(budget_id, limit=10)
    txns = where(budget_id: budget_id)
    txns = txns.miscellaneous_transactions
    txns = txns.joins(:payee).where('is_system = ? && is_account = ?',false,false)
    txns = txns.group("payees.name")
    txns = txns.select("payees.name as name, sum(debit) as total_expense")
    txns = txns.order("total_expense DESC").first(limit)
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

  def add_category_tag
    self.tag_list.add(self.category.name)
  end

  def update_mortgage_account_balance
    unless self.payee.account.nil?
      if self.payee.account.account_type.name == "Mortgage"
        if !self.debit.nil? && self.debit > 0
          house = House.where('mortgage_account_id = ?',self.payee.account.id).first()
          interest = house.get_interest_payable_for_month.to_f
          principal = self.debit.to_f - interest
          update_account_balance_for_non_budget_accounts(self.payee.account,self.mortgage_principal,principal,self.credit_was,self.credit)

          unless self.destroyed?
            self.mortgage_interest = interest
            self.mortgage_principal = principal
          end
        elsif !self.credit.nil? && self.credit > 0
          update_account_balance_for_non_budget_accounts(self.payee.account,self.debit_was,self.debit,self.credit_was,self.credit)
        end
      end
    end
  end

  private

  def update_account_balance_for_non_budget_accounts(account,old_debit_amount,debit_amount,old_credit_amount,credit_amount)
    if !debit_amount.nil? && debit_amount > 0
      account.balance += old_debit_amount if !old_debit_amount.nil? && old_debit_amount > 0
      account.balance -= debit_amount unless self.destroyed?
    elsif !credit_amount.nil? && credit_amount > 0
      account.balance -=  old_credit_amount if !old_credit_amount.nil? && old_credit_amount > 0
      account.balance += credit_amount unless self.destroyed?
    end

    account.save!
  end

end
