class House < ActiveRecord::Base
  ##################################
  # Relationships
  ##################################
  belongs_to :mortgage_account, :class_name => 'Account', :foreign_key => 'mortgage_account_id'
  belongs_to :offset_account, :class_name => 'Account', :foreign_key => 'offset_account_id'

  ##################################
  # Validations
  ##################################
  validates_uniqueness_of :name,:address,:mortgage_account_id,:offset_account_id
  validates_presence_of :name,:address,:mortgage_account_id,:price_paid,:original_balance,:current_value,:interest_rate,:term_length,:purchase_date,:term_start_date,:monthly_payment
  validates_numericality_of :mortgage_account_id,:price_paid,:original_balance,:current_value,:interest_rate,:term_length,:monthly_payment

  ##################################
  # Callbacks
  ##################################
  after_create :update_schedule_and_debit_one_click_for_category
  after_update :update_schedule_and_debit_one_click_for_category

  ##################################
  # Scoped Methods
  ##################################


  ##################################
  # Class Methods
  ##################################
  def current_balance
    self.mortgage_account.balance.to_f.round(2)
  end

  def current_balance_with_offset
    balance_with_offset = self.current_balance.to_f-self.offset_account.balance.to_f
    if balance_with_offset <= 0
      balance_with_offset = 0
    end

    return balance_with_offset

  end

  def mortgage_paid
    payee = Payee.find_by_account_id(self.mortgage_account.id)
    debits = BudgetTransaction.where('payee_id = ?',payee).sum('debit')
    credits = BudgetTransaction.where('payee_id = ?',payee).sum('credit')
    return debits-credits
  end

  def get_mortgage_payments(balance,offset_balance)
    balance = balance.to_f
    annual_rate = get_annual_interest_rate
    monthly_rate = get_monthly_interest_rate
    n = self.term_length*12
    offset = offset_balance.to_f
    term = (1 + monthly_rate)**n
    # monthly_payment = balance * (monthly_rate * term / (term - 1))
    monthly_payment = self.monthly_payment

    # puts "Loan term (Number of payments) [#{n}]"
    # puts "Annual interest rate [#{annual_rate*100}]"
    # puts "Monthly interest rate [#{monthly_rate}]"
    # puts "Term = [#{term}]"
    # puts "Monthly Payment = [#{monthly_payment}]"

    mortgage_payments = Array.new
    month=0
    while (balance > offset)
      month += 1
      interest_payment = (balance-offset).to_f * monthly_rate
      if interest_payment <= 0
        interest_payment = 0
      end
      principal_payment = monthly_payment - interest_payment
      balance = balance - principal_payment
      mortgage_payments << MortgagePayment.new(month: month, interest_payment: interest_payment, principal_payment: principal_payment, balance: balance)

      puts("Interest [$#{interest_payment}], Principal [$#{principal_payment}], Balance = [$#{balance}]")
    end

    return mortgage_payments
  end

  def get_interest_payable_for_month
      return self.current_balance_with_offset.to_f * get_monthly_interest_rate.to_f
  end

  private

  def get_annual_interest_rate
    return self.interest_rate.to_f * 0.01
  end

  def get_monthly_interest_rate
    return get_annual_interest_rate / 12.to_f
  end

  def update_schedule_and_debit_one_click_for_category
  end

end
