class AccountTransaction < ActiveRecord::Base
  attr_accessor :transaction_type
  acts_as_taggable
  ##################################
  # Relationships
  ##################################
  belongs_to :account
  belongs_to :budget
  belongs_to :payee
  belongs_to :category

  ##################################
  # Validations
  ##################################
  validates_presence_of :account_id,:payee_id,:budget_id
  validates_numericality_of :payee_id, :account_id,:amount
  validate :amount_cannot_be_greater_than_payee_balance

  ##################################
  # Callbacks
  ##################################
  after_create :update_budget_accounts_and_account_balance, :update_account_payees_and_account_balance, :add_category_tag
  after_update :update_budget_accounts_and_account_balance, :update_account_payees_and_account_balance
  after_destroy :update_budget_accounts_and_account_balance, :update_account_payees_and_account_balance


  ##################################
  # Scoped Methods
  ##################################

  ##################################
  # Class Methods
  ##################################

  ##################################
  # Validation Methods
  ##################################
  def amount_cannot_be_greater_than_payee_balance
    if self.amount > self.account.balance
      errors.add(:amount, "can't be greater than account's balance")
    end
  end

  private

  def update_budget_accounts_and_account_balance
    # update the budget account opening balance with the new balance
    puts '------------enetered'
    budget_account = BudgetAccount.find_by_budget_id_and_account_id(self.budget.id, self.account.id)

    if !amount.nil? && amount > 0
      unless budget_account.nil?
        puts '-----------------Account with BudgetAccount'
        puts 'budget account amount was = '+ self.amount_was.to_s
        puts 'budget account opening balance was = '+ budget_account.opening_balance.to_s
        budget_account.opening_balance += self.amount_was if !self.amount_was.nil? && self.amount_was > 0
        puts 'budget account opening balance after removing old charge = '+ budget_account.opening_balance.to_s
        budget_account.opening_balance -= self.amount unless self.destroyed?
        puts 'budget account amount added = '+ self.amount.to_s
        puts 'budget account opening balance is = '+ budget_account.opening_balance.to_s
        budget_account.save!
        budget_account.update_future_budget_accounts
      else
        puts '-----------------Account'
        puts 'account amount was = '+ self.amount_was.to_s
        puts 'account opening balance was = '+ self.account.balance.to_s
        self.account.balance += self.amount_was if !self.amount_was.nil? && self.amount_was > 0
        puts 'account opening balance after removing old charge = '+ self.account.balance.to_s
        self.account.balance -= self.amount unless self.destroyed?
        puts 'account amount added = '+ self.amount.to_s
        puts 'account opening balance is = '+ self.account.balance.to_s
        self.account.save!
      end
    end
  end

  def update_account_payees_and_account_balance
    # update the budget account opening balance with the new balance

    if self.payee.is_account
      puts 'payee is account'

      budget_account = BudgetAccount.find_by_budget_id_and_account_id(self.budget.id, self.payee.account.id)
      if !amount.nil? && amount > 0
        unless budget_account.nil?
          puts '-----------------Payee with BudgetAccount'
          puts 'budget account amount was = '+ self.amount_was.to_s
          puts 'budget account opening balance was = '+ budget_account.opening_balance.to_s
          budget_account.opening_balance -= self.amount_was if !self.amount_was.nil? && self.amount_was > 0
          puts 'budget account opening balance after removing old charge = '+ budget_account.opening_balance.to_s
          budget_account.opening_balance += self.amount unless self.destroyed?
          puts 'budget account amount added = '+ self.amount.to_s
          puts 'budget account opening balance is = '+ budget_account.opening_balance.to_s
          budget_account.save!
          budget_account.update_future_budget_accounts
        else
          puts '-----------------Payee'
          puts 'account amount was = '+ self.amount_was.to_s
          puts 'account opening balance was = '+ self.payee.account.balance.to_s
          self.payee.account.balance -= self.amount_was if !self.amount_was.nil? && self.amount_was > 0
          puts 'account opening balance after removing old charge = '+ self.payee.account.balance.to_s
          self.payee.account.balance += self.amount unless self.destroyed?
          puts 'account amount added = '+ self.amount.to_s
          puts 'account opening balance is = '+ self.payee.account.balance.to_s
          self.account.save!
        end
      end
    end
  end

  def add_category_tag
    self.tag_list.add(self.category.name) unless self.category.nil?
  end

end
