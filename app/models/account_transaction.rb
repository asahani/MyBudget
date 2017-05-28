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
  validates_presence_of :amount,:category_id,:transaction_date
  validates_numericality_of :amount
  validate :amount_cannot_be_greater_than_payee_balance , unless: "account_id.nil?"

  ##################################
  # Callbacks
  ##################################
  after_create :update_budget_accounts_and_account_balance, :update_account_payees_and_account_balance, :add_category_tag, :update_goals
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
    budget_account = nil
    unless self.budget.nil? || self.account.nil?
      budget_account = BudgetAccount.find_by_budget_id_and_account_id(self.budget.id, self.account.id)
    end

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
        if !self.account.nil?
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
  end

  def update_account_payees_and_account_balance
    # update the budget account opening balance with the new balance

    if !self.payee.nil? && self.payee.is_account
      puts 'payee is account'
      budget_account = nil
      unless self.budget.nil? || self.payee.nil?
        budget_account = BudgetAccount.find_by_budget_id_and_account_id(self.budget.id, self.payee.account.id)
      end

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
          if !self.payee.nil?
            puts '-----------------Payee'
            puts 'account amount was = '+ self.amount_was.to_s
            puts 'account opening balance was = '+ self.payee.account.balance.to_s
            self.payee.account.balance -= self.amount_was if !self.amount_was.nil? && self.amount_was > 0
            puts 'account opening balance after removing old charge = '+ self.payee.account.balance.to_s
            self.payee.account.balance += self.amount unless self.destroyed?
            puts 'account amount added = '+ self.amount.to_s
            puts 'account opening balance is = '+ self.payee.account.balance.to_s
            self.payee.account.save!
          end
        end
      end
    end
  end

  def add_category_tag
    self.tag_list.add(self.category.name) unless self.category.nil?
  end

  def update_goals
    unless self.payee.nil?
      unless self.payee.account.nil?
        self.payee.account.goals.each do |goal|
          amount_for_goal = ((self.amount.to_f * goal.percentage_towards_goal) / 100).round(2)
          puts 'amount for goal = '
          puts amount_for_goal
          goal.saved_amount += amount_for_goal
          goal.save!
        end
      end
    end
  end

end
