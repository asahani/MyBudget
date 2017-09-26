class BudgetIncome < ApplicationRecord
  ##################################
  # Relationships
  ##################################
  belongs_to :income
  belongs_to :account
  belongs_to :budget
  belongs_to :budget_transaction

  ##################################
  # Validations
  ##################################
  validates_presence_of :description, :amount, :budget_id
  validates_numericality_of :amount, :account_id, :budget_id
  validates_numericality_of :income_id, :allow_nil => true
  ##################################
  # Callbacks
  ##################################
  after_create :create_income_transaction #, :auto_generate_income_splits
  after_update :update_income_transaction, :regenerate_income_splits
  ##################################
  # Scoped Methods
  ##################################

  ##################################
  # Class Methods
  ##################################

  def regenerate_income_splits
    puts 'Regenerate Income splits called.'
    splits = IncomeSplit.where("income_id = ? and budget_id = ?",self.income_id,self.budget_id).destroy_all
    auto_generate_income_splits
  end

  def auto_generate_income_splits
    puts 'Auto generate Income splits called.'
    unless self.income_id.nil?
      prev_months_budget = Budget.find_by_start_date(self.budget.start_date.prev_month)

      unless prev_months_budget.nil?
        last_income_split = IncomeSplit.find_by_budget_id_and_income_id_and_is_last_for_month(prev_months_budget.id,self.income.id,true)

        unless last_income_split.nil?
          starting_income_for_next_month = self.income.amount - last_income_split.amount

          if starting_income_for_next_month < 0
            starting_income_for_next_month = 0
          end

          if self.income.monthly
            generate_income_splits(last_income_split.income_split_date.next_month, starting_income_for_next_month)
          else
            generate_income_splits(last_income_split.income_split_date, starting_income_for_next_month)
          end
        end
      end
    end
  end

  def generate_income_splits(first_split_date, initial_income)
    split_income = self.income.amount
    total_monthly_income = self.amount
    if self.income.weekly
       calculate_splits(first_split_date,initial_income,split_income,total_monthly_income,7)
   elsif self.income.fortnightly
      calculate_splits(first_split_date,initial_income,split_income,total_monthly_income,14)
    elsif self.income.monthly
      income_split = IncomeSplit.new(budget_id: self.budget.id, income_id: self.income.id, income_split_date: first_split_date,
          amount: self.amount,total_received: self.amount, is_last_for_month: true)
      income_split.save!
    end
  end

  # private
  def create_income_transaction
    payee = Payee.find(1)

    # create transaction
    budget_txn = BudgetTransaction.new(account_id: self.account.id, budget_item_id: nil, payee_id: payee.id,
      budget_id: self.budget.id,category_id: payee.category.id, credit: self.amount, debit: 0.00,
      transaction_date: Time.now.to_date,comments: self.description,raw_data: nil,
      manual: false, scheduled: false, budgeted: true,miscellaneous: false, savings: false,reconciled: true)

    budget_txn.save!

    self.budget_transaction = budget_txn
    self.credited = true
    self.save!
  end

  def update_income_transaction
    self.budget_transaction.credit = self.amount
    self.budget_transaction.save!
  end

  def calculate_splits(start_date,starting_salary,split_income,total_monthly_income, salary_interval_in_days)
    total_salary = starting_salary.to_f
    current_week = start_date
    income_splits = Array.new
    month_complete = false
    first_week = true
    next_month = 0

    while month_complete == false do
        if first_week
          # weeks << Week.new(current_week,starting_salary,total_salary,next_month)
          income_splits << IncomeSplit.new(budget_id: self.budget.id, income_id: self.income.id, income_split_date: current_week,
            amount: starting_salary.to_f,total_received: total_salary, is_last_for_month: false)
          first_week = false
        elsif total_salary <= total_monthly_income.to_f
          # weeks << Week.new(current_week,split_income,total_salary,next_month)
           income_splits << IncomeSplit.new(budget_id: self.budget.id, income_id: self.income.id, income_split_date: current_week,
              amount: split_income.to_f,total_received: total_salary, is_last_for_month: false)
        end
        if total_salary > total_monthly_income.to_f
          next_month = total_salary - total_monthly_income
          total_salary -= next_month
          remaining_for_month = split_income - next_month
          # weeks << Week.new(current_week,remaining_for_month,total_salary,next_month)
          income_splits << IncomeSplit.new(budget_id: self.budget.id, income_id: self.income.id, income_split_date: current_week,
              amount: remaining_for_month,total_received: total_salary, is_last_for_month: true)
          total_salary = next_month
          next_month = 0
          month_complete = true
        end
        current_week = current_week + salary_interval_in_days.to_i
        total_salary += split_income
    end

    # puts "Date - amount - total - islast"
    income_splits.each do |income_split|
      # puts week.income_split_date.to_s + " - " + week.amount.to_s + " - " + week.total_received.to_s + " - " + week.is_last_for_month.to_s
      income_split.save!
    end
  end

  # def get_budget_month_start_date(txn_date)
  #   #TODO: get Start Date from config
  #   month_start_day = 15
  #
  #   date_date = txn_date.day
  #   date_start_month = txn_date.month
  #   date_year = txn_date.year
  #
  #   if (date_date < month_start_day)
  #     date_start_month = txn_date.prev_month.month
  #     date_year = txn_date.prev_month.year
  #   end
  #
  #   return Date.new(date_year,date_start_month,month_start_day)
  # end
end
