class NetWorth < ApplicationRecord
  ##################################
  # Relationships
  ##################################
  belongs_to :budget

  ##################################
  # Validations
  ##################################
  validates :budget_id, uniqueness: { scope: [:account_id,:share_id,:house_id]}
  validates_presence_of :capture_date, :value
  validates_numericality_of :value

  def self.capture_net_worth_for_budget(budget)
    mortgage_account_type = AccountType.find_by_name("Mortgage")
    #capture accounts
    Account.all.active.each do| account |
      # if account.budget_account
      #   budget_account = BudgetAccount.find_by_budget_id_and_account_id(budget.id,account.id)
      #   net_worth = NetWorth.new(account_id: account.id, budget_id: budget.id, capture_date: Date.today,value: budget_account.balance)
      #   net_worth.save!
      # else
      if account.account_type.id ==  mortgage_account_type.id
        net_worth = NetWorth.new(account_id: account.id, budget_id: budget.id, capture_date: Date.today,value: (account.balance * -1))
      else
        net_worth = NetWorth.new(account_id: account.id, budget_id: budget.id, capture_date: Date.today,value: account.balance)
      end
      net_worth.save!
      # end
    end
    #capture investments  - Shares
    Share.all.active.each do | share|
      share.set_share_details
      net_worth = NetWorth.new(share_id: share.id, budget_id: budget.id, capture_date: Date.today,value: share.get_holding_value)
      net_worth.save!
    end
    #capture Innvestments - House
    House.all.each do | house|
      net_worth = NetWorth.new(house_id: house.id, budget_id: budget.id, capture_date: Date.today,value: house.current_value)
      net_worth.save!
    end
  end
end
