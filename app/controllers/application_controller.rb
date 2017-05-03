class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
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
