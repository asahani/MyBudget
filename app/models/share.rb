class Share < ActiveRecord::Base
  attr_accessor :share_details
  ##################################
  # Relationships
  ##################################
  belongs_to :brokerage_account, :class_name => 'Account', :foreign_key => 'brokerage_account_id'
  has_many :dividened_incomes, :class_name => 'BudgetIncome', :foreign_key => 'dividend_income_share_id'
  has_many :account_transactions, :class_name => 'AccountTransaction', :foreign_key => 'share_id'

  ##################################
  # Validations
  ##################################
  validates_presence_of :name, :code,:share_type, :units,:purchase_date,:purchase_price,:brokerage_account_id
  validates_numericality_of :units,:purchase_price,:brokerage_account_id
  validates_numericality_of :sell_price, :allow_nil => true
  validate :ensure_sufficient_money_to_purchase_shares, :on => :create
  ##################################
  # Callbacks
  ##################################
  # after_initialize :set_share_details
  # after_find :set_share_details
  after_create :deduct_amount_from_brokerage_account

  ##################################
  # Scoped Methods
  ##################################
  scope :active, -> { where('sell_price IS NULL')}

  ##################################
  # Class Methods
  ##################################
  def ensure_sufficient_money_to_purchase_shares
    unless self.no_cash_transaction
      amount_required = self.units * self.purchase_price.to_f
      if amount_required > self.brokerage_account.balance
        errors.add(:purchase_price, amount_required.to_s + " is greater than brogerage account's balance")
      end
    end
  end

  def deduct_amount_from_brokerage_account
    unless self.no_cash_transaction
      total_purchase_price = self.units * self.purchase_price.to_f
      comment = "Purchased "+self.units.to_s+ " "+self.name+" shares for $"+total_purchase_price.to_s

      account_txn = AccountTransaction.new(account_id: self.brokerage_account.id,payee_id: nil,
        budget_id: nil,category_id: Category.find_by_name("Investment").id, amount: total_purchase_price,
        transaction_date: Date.today, comments: comment,reconciled: true, share_id: self.id)

      account_txn.save!
    end
  end

  def set_share_details
    @share_details = get_share_details

    unless self.share_details.nil?
      self.last_price = self.share_details.last_trade_price_only
      self.save!
    end
  end

  def get_share_price
      return self.last_price
  end

  def get_purchase_cost
    (self.units * self.purchase_price).to_f.round(2)
  end

  def get_profit_loss_value
    self.get_holding_value - self.get_purchase_cost
  end

  def get_profit_loss_percentage
    (self.get_profit_loss_value/self.get_purchase_cost).to_f*100
  end

  def get_share_details
    begin
      details = StockQuote::Stock.quote(self.code)

      details = (details.response_code == 200) ? details : nil

      return details
    rescue
      puts 'Unable to get stock details'
      self.errors.add(:base, "Unable to get stock details")
      return nil
    end
  end

  def get_holding_value
    if self.last_price.nil?
      self.set_share_details
    end
    (self.last_price * self.units).to_f.round(2) unless self.last_price.nil?
  end

  def get_percent_change_value
    change_value = 0
    change_percent = self.share_details.percent_change.to_f unless self.share_details.nil?
    change_value = ((self.get_holding_value * change_percent)/100).to_f.round(2)

    return change_value
  end

  def get_share_history(start_date=(Time.now-1.year).to_date,end_date=Date.today)
    begin
      return StockQuote::Stock.json_history(self.code,start_date,end_date,['Date','Close'])['quote'].reverse
    rescue
      puts 'Unable to get stock history'
      self.errors.add(:base, "Unable to get stock history")
      return []
    end
  end
end
