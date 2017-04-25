class Budget < ActiveRecord::Base
  ##################################
  # Relationships
  ##################################
  has_many :budget_items
  has_many :budget_incomes
  has_many :budget_transactions
  has_many :budget_accounts

  ##################################
  # Validations
  ##################################
  validates_uniqueness_of :start_date
  validates_presence_of :year, :month, :start_date, :end_date
  validates_numericality_of :year
  validates :month, :numericality => { :greater_than => 0, :less_than_or_equal_to => 13 }

  ##################################
  # Callbacks
  ##################################
  after_create :create_budget_items, :create_budget_accounts, :create_income

  ##################################
  # Scoped Methods
  ##################################
  scope :future_budgets, -> { where('start_date > ?',self.start_date)}

  ##################################
  # Class Methods
  ##################################

  def self.get_budget(txn_date)
    #TODO: get Start Date from config
    month_start_day = 15

    budget = Budget.where('start_date <= ? and end_date >= ?',txn_date,txn_date).first

    if budget.nil?
      date_date = txn_date.day
      date_start_month = txn_date.month
      date_year = txn_date.year

      if (date_date < month_start_day)
        date_start_month = txn_date.prev_month.month
        date_year = txn_date.prev_month.year
      end

      start_date = Date.new(date_year,date_start_month,month_start_day)
      end_date = start_date.next_month.prev_day
      budget = Budget.new(year: date_year,month: date_start_month,start_date: start_date,end_date: end_date)
      budget.save!
    end

    return budget
  end

  def previous_budget
    previous_budget = Budget.find_by_start_date(self.start_date.prev_month)
    return previous_budget
  end

  def next_budget
    previous_budget = Budget.find_by_start_date(self.start_date.next_month)
    return previous_budget
  end

  # def display_budget_itemss
  #   display_budget_items = budget_items.order(:category_id).reject { |r| r.category.miscellaneous == true }
  #   misc_budget_item = BudgetItem.joins(:category).where('budget_id = ? && categories.miscellaneous = ? && categories.active = ?',id,true,true)
  #   display_budget_items << misc_budget_item.first
  #   return display_budget_items
  # end

  def display_budget_items
    budget_items_display_list = Array.new
    master_categories = MasterCategory.where(display: true)
    master_categories.each do |master_category|
      items_list = Array.new
      budgted = 0
      expenses = 0
      balance = 0
      items_found = false
      master_category.categories.each do |category|
        items = BudgetItem.where('budget_id = ? && category_id = ?',id,category.id)
        if !items.nil? && items.count > 0
          budgted += items.sum(:budgeted_amount)
          expenses += items.sum(:expenses)
          balance += items.sum(:balance)
          items_list += items
          items_found = true
        end
      end

      if items_found == true
        display_item = DisplayList.new(master_category: master_category,budgeted: budgted,expenses: expenses,balance: balance,categorised_items: items_list)
        budget_items_display_list << display_item
      end
    end

    misc_budget_item_arr = BudgetItem.joins(:category).where('budget_id = ? && categories.miscellaneous = ? && categories.active = ? && mandatory = ?',id,true,false,true)
    misc_budget_item = misc_budget_item_arr.first

    display_item = DisplayList.new(master_category: misc_budget_item.category.master_category,budgeted: misc_budget_item.budgeted_amount,
      expenses: misc_budget_item.expenses,balance: misc_budget_item.balance,categorised_items: Array.new)
    budget_items_display_list << display_item

    return budget_items_display_list
  end

  def display_miscellaneous_items
    budget_items_display_list = Array.new
    master_categories = MasterCategory.where(display: true)
    master_categories.each do |master_category|
      items_list = Array.new
      debit = 0
      credit = 0
      items_found = false
      master_category.categories.each do |category|
        items = BudgetTransaction.where('budget_id = ? && miscellaneous = ? && category_id = ?',id,true,category.id)

        if !items.nil? && items.count > 0
          debit += items.sum(:debit)
          credit += items.sum(:credit)
          items_list += items
          items_found = true
        end
      end
      if items_found == true
        expenses = debit-credit
        display_item = DisplayList.new(master_category: master_category,budgeted: 0,expenses: expenses,balance: 0,categorised_items: items_list)
        budget_items_display_list << display_item
      end
    end

    return budget_items_display_list
  end

  def clear_budget_accounts
    unknown_category = Category.find_by_name("Unknown")
    unknown_payee = Payee.find_by_name("Unknown")

    self.budget_accounts.transaction_account.each do |budget_account|
      if budget_account.balance > 0
        budget_txn = BudgetTransaction.new(account_id: budget_account.account.id,budget_item_id: nil,payee_id: unknown_payee.id,
          budget_id: self.id,category_id: unknown_category.id, credit: 0, debit: budget_account.balance,
          transaction_date: Date.today,comments: "Closing budget",raw_data: nil ,
          manual: true, scheduled: false, budgeted: false,miscellaneous: false,savings: false,reconciled: true,tag_list: "Unknown")

        budget_txn.save!
      end
    end
  end

  private
  def create_budget_items
    categories = Category.where("mandatory=? && active=? && miscellaneous=? && savings=?",true,true,false,false);
    categories.each do |category|
        budget_item = BudgetItem.new(budget_id: self.id,category_id: category.id,budgeted_amount: category.budget_amount)
        budget_item.save!
    end
    misc = Category.find_by_miscellaneous_and_active_and_mandatory(true,false,true);
    budget_item = BudgetItem.new(budget_id: self.id,category_id: misc.id,budgeted_amount: misc.budget_amount)
    budget_item.save!
  end

  def create_budget_accounts
    accounts = Account.where('budget_account = ? and is_active = ?',true,true)
    accounts.each do |account|
      budget_account = BudgetAccount.new(budget_id: self.id, account_id: account.id, balance: 0.00)
      budget_account.save!
    end
  end

  def create_income
    incomes = Income.where('is_active = ?',true)
    incomes.each do |income|
      budget_income = BudgetIncome.new(income_id: income.id, budget_id: self.id, description: income.description,amount: income.monthly_income,  account_id: income.account_id)
      budget_income.save!
    end
  end

end
