class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_net_worth

  def net_worth_details
    net_worth = Hash.new
    net_worth[:accounts] = Array.new
    net_worth[:total] = 0

    banking = Hash.new

    #list transaction accounts
    banking[:name] = "Banking"
    banking[:code] = "blue"
    banking[:accounts] = Array.new
    banking[:total] = 0

    transaction_accounts_hash = create_account_type_details_for_net_worth("Transaction",Account.transaction_account.active)
    banking[:accounts] << transaction_accounts_hash
    banking[:total] += transaction_accounts_hash[:total]

    savings_accounts = Account.savings_account.active
    savings_accounts += Account.offset_account.active
    savings_accounts_hash = create_account_type_details_for_net_worth("Savings",savings_accounts)
    banking[:accounts] << savings_accounts_hash
    banking[:total] += savings_accounts_hash[:total]

    credit_accounts_hash = create_account_type_details_for_net_worth("Credit",Account.credit_account.active)
    banking[:accounts] << credit_accounts_hash
    banking[:total] += credit_accounts_hash[:total]

    #---------------------------------------------------
    investments = Hash.new
    #list investments
    investments[:name] = "Investments"
    investments[:code] = "green"
    investments[:accounts] = Array.new
    investments[:total] = 0
    #xxxxxxxxx BROKERAGE ACCOUNTS
    brokerage_accounts_hash = create_account_type_details_for_net_worth("Brokerage",Account.brokerage_account.active)
    investments[:accounts] << brokerage_accounts_hash
    investments[:total] += brokerage_accounts_hash[:total]

    #xxxxxxxxx SHARES
    shares_hash = Hash.new
    shares_hash[:name] = "Shares"
    shares_hash[:accounts] = Array.new
    shares_hash[:total] = 0

    Share.all.active.each do |share|
      shares_hash[:total] += share.get_holding_value
    end
    shr = Hash.new
    shr[:name] = "all Shares"
    shr[:balance] = shares_hash[:total]
    shares_hash[:accounts] << shr

    investments[:accounts] << shares_hash
    investments[:total] += shares_hash[:total]

    #xxxxxxxxx LOANS GIVEN
    loan_accounts_hash = create_account_type_details_for_net_worth("Loans Given",Account.loan_account.active)
    investments[:accounts] << loan_accounts_hash
    investments[:total] += loan_accounts_hash[:total]

    #---------------------------------------------------
    assets = Hash.new
    #list property
    assets[:name] = "Assets"
    assets[:code] = "grey"
    assets[:accounts] = Array.new
    assets[:total] = 0

    property_hash = Hash.new
    property_hash[:name] = "Property"
    property_hash[:accounts] = Array.new
    property_hash[:total] = 0

    House.all.each do |house|
      hse = Hash.new
      hse[:name] = house.name
      hse[:balance] = house.current_value
      property_hash[:accounts] << hse
      property_hash[:total] += house.current_value
    end

    assets[:accounts] << property_hash
    assets[:total] += property_hash[:total]
    #---------------------------------------------------
    debts = Hash.new
    #list debts
    debts[:name] = "Debts"
    debts[:code] = "red"
    debts[:accounts] = Array.new
    debts[:total] = 0

    #xxxxxxxxx Mortgage ACCOUNTS
    mortgage_accounts_hash = create_account_type_details_for_net_worth("Mortgage",Account.mortgage_account.active,true)
    debts[:accounts] << mortgage_accounts_hash
    debts[:total] -= mortgage_accounts_hash[:total]

    #---------------------------------------------------
    # add categories to master list
    net_worth[:accounts] << banking
    net_worth[:accounts] << investments
    net_worth[:accounts] << assets
    net_worth[:accounts] << debts
    net_worth[:total] += banking[:total]
    net_worth[:total] += investments[:total]
    net_worth[:total] += assets[:total]
    net_worth[:total] += debts[:total]

    return net_worth
  end

  def get_annual_report(budget_year)
    no_of_budgets = 0
    annual_report = Hash.new

    annual_report[:month_name] = Array.new(12)
    annual_report[:income] = Array.new(13)
    annual_report[:expenses] = Array.new(13)
    annual_report[:savings] = Array.new(13)
    annual_report[:savings_expenses] = Array.new(13)
    annual_report[:total_expenses] = Array.new(13)
    annual_report[:overall_savings] = Array.new(13)
    annual_report[:remaining] = Array.new(13)
    annual_report[:misc_percentage] = Array.new(13)
    annual_report[:budgeted_amount] = Array.new(13)

    annual_report[:yearly_budgeted_amount] = Array.new(13)
    annual_report[:yearly_income] = Array.new(13)
    annual_report[:yearly_savings] = Array.new(13)
    annual_report[:yearly_expenses] = Array.new(13)
    annual_report[:income_expense_difference] = Array.new(13)

    total_income = 0
    total_expenses = 0
    total_savings = 0
    total_savings_expenses = 0
    total_total_expenses = 0
    total_overall_savings = 0
    total_remaining = 0
    total_misc_percentage = 0
    total_budgeted_amount = 0

    total_yearly_budgeted_amount = 0
    total_yearly_income = 0
    total_yearly_savings = 0
    total_yearly_expenses = 0
    total_income_expense_difference = 0

    default_budgeted_amount = nil
    default_income = nil
    default_savings = nil


    for budget_month in 0..11
      puts "month----------------"
      puts budget_month
      annual_report[:month_name][budget_month] = I18n.t("date.abbr_month_names")[budget_month+1]
      puts annual_report[:month_name][budget_month]
      budget = Budget.find_by_month_and_year(budget_month + 1,budget_year)

      unless budget.nil?
        no_of_budgets += 1
        default_budgeted_amount = budget.budgeted_amount
        default_income = budget.income
        default_savings = default_income.to_f - default_budgeted_amount.to_f

        annual_report[:income][budget_month] = budget.income
        annual_report[:expenses][budget_month] = budget.expenses
        annual_report[:savings][budget_month] = budget.savings
        annual_report[:savings_expenses][budget_month] = budget.savings_expenses
        annual_report[:total_expenses][budget_month] = annual_report[:expenses][budget_month]  + annual_report[:savings_expenses][budget_month]
        annual_report[:overall_savings][budget_month] = annual_report[:savings][budget_month] - annual_report[:savings_expenses][budget_month]
        annual_report[:remaining][budget_month] = budget.income_remaining
        annual_report[:misc_percentage][budget_month] = budget.miscellaneous_expenses_percentage
        annual_report[:budgeted_amount][budget_month] = budget.budgeted_amount

        annual_report[:yearly_budgeted_amount][budget_month] = annual_report[:budgeted_amount][budget_month]
        annual_report[:yearly_income][budget_month]  = annual_report[:income][budget_month]
        annual_report[:yearly_savings][budget_month]  = annual_report[:savings][budget_month]
        annual_report[:yearly_expenses][budget_month]  = annual_report[:expenses][budget_month]

        annual_report[:income_expense_difference][budget_month] = annual_report[:income][budget_month] - annual_report[:expenses][budget_month]

        total_income += annual_report[:income][budget_month]
        total_expenses +=   annual_report[:expenses][budget_month]
        total_savings += annual_report[:savings][budget_month]
        total_savings_expenses  += annual_report[:savings_expenses][budget_month]
        total_total_expenses  += annual_report[:total_expenses][budget_month]
        total_overall_savings += annual_report[:overall_savings][budget_month]
        total_remaining += annual_report[:remaining][budget_month]
        total_misc_percentage += annual_report[:misc_percentage][budget_month]
        total_budgeted_amount += annual_report[:budgeted_amount][budget_month]

        total_yearly_budgeted_amount += annual_report[:budgeted_amount][budget_month]
        total_yearly_income += annual_report[:income][budget_month]
        total_yearly_savings += annual_report[:savings][budget_month]
        total_yearly_expenses += annual_report[:expenses][budget_month]

        total_income_expense_difference += annual_report[:income_expense_difference][budget_month]
      else
        annual_report[:yearly_budgeted_amount][budget_month] = default_budgeted_amount
        annual_report[:yearly_income][budget_month] = default_income
        annual_report[:yearly_savings][budget_month] = default_savings
        annual_report[:yearly_expenses][budget_month] = default_budgeted_amount
        unless default_income.nil? || default_budgeted_amount.nil?
          annual_report[:income_expense_difference][budget_month] = default_income - default_budgeted_amount
        else
          annual_report[:income_expense_difference][budget_month] = 0
        end

        total_yearly_budgeted_amount += default_budgeted_amount unless default_budgeted_amount.nil?
        total_yearly_income += default_income unless default_income.nil?
        total_yearly_savings += default_savings unless default_savings.nil?
        total_yearly_expenses += default_budgeted_amount unless default_budgeted_amount.nil?
        unless default_income.nil? || default_budgeted_amount.nil?
          total_income_expense_difference += default_income - default_budgeted_amount
        end
      end

    end

    annual_report[:income][12] = total_income
    annual_report[:expenses][12] = total_expenses
    annual_report[:savings][12] = total_savings
    annual_report[:savings_expenses][12]  = total_savings_expenses
    annual_report[:total_expenses][12] = total_total_expenses
    annual_report[:overall_savings][12] = total_overall_savings
    annual_report[:remaining][12] = total_remaining
    annual_report[:misc_percentage][12] = no_of_budgets > 0 ? (total_misc_percentage.to_f / no_of_budgets.to_f).to_f.round(2) : 0
    annual_report[:budgeted_amount][12] = total_budgeted_amount

    annual_report[:yearly_budgeted_amount][12] = total_yearly_budgeted_amount
    annual_report[:yearly_income][12] = total_yearly_income
    annual_report[:yearly_savings][12] = total_yearly_savings
    annual_report[:yearly_expenses][12] = total_yearly_expenses

    annual_report[:income_expense_difference][12] = total_income_expense_difference

    return annual_report
  end
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :current_password])
  end

  private

  def create_account_type_details_for_net_worth(account_type,accounts, is_negetive=false)
    accounts_hash = Hash.new
    accounts_hash[:name] = account_type
    accounts_hash[:accounts] = Array.new
    accounts_hash[:total] = 0

    accounts.each do |account|
      acc = Hash.new
      acc[:name] = account.name
      acc[:balance] = is_negetive ? (account.balance * -1) : account.balance
      accounts_hash[:accounts] << acc
      accounts_hash[:total] += account.balance
    end

    return accounts_hash
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_net_worth
    @net_worth = net_worth_details
  end
end
