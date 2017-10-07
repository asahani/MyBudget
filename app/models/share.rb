class Share < ActiveRecord::Base
  attr_accessor :share_details
  ##################################
  # Relationships
  ##################################
  belongs_to :brokerage_account, :class_name => 'Account', :foreign_key => 'brokerage_account_id'
  has_many :dividened_incomes, :class_name => 'BudgetIncome', :foreign_key => 'dividend_income_share_id'
  has_many :budget_transactions, :class_name => 'BudgetTransaction', :foreign_key => 'share_id'

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
  after_initialize :set_share_details
  # after_find :set_share_details
  after_create :deduct_amount_from_brokerage_account

  ##################################
  # Scoped Methods
  ##################################
  scope :active, -> { where('sell_price IS NULL')}
  scope :sold, -> { where('sell_price > 0')}
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
      payee = Payee.find_by_name("Share Purchase")

      budget_txn = BudgetTransaction.new(account_id: self.brokerage_account.id,payee_id: payee.id,
        budget_item_id: nil, budget_id: nil,category_id: Category.find_by_name("Investment").id, debit: total_purchase_price,
        transaction_date: Date.today, comments: comment,reconciled: true, share_id: self.id,share: true,miscellaneous: false)

      budget_txn.save!
    end
  end

  def set_share_details
    self.share_details = get_share_details

    unless self.share_details.nil?
      # self.last_price = self.share_details.last_trade_price_only
      self.last_price = self.share_details["l"]
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

  def get_holding_value
    if self.last_price.nil?
      self.set_share_details
    end

    return (self.last_price * self.units).to_f.round(2) unless self.last_price.nil?
  end

  def get_percent_change_value
    change_value = 0
    change_percent = 0
    change_percent = self.share_details["cp"].to_f unless self.share_details.nil?

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

  def get_google_data(share_code)
    uri_string = 'https://finance.google.com/finance?q='+ share_code + '&output=json'
    uri = URI(uri_string)

    nhttp = Net::HTTP.new(uri.host, uri.port)
    nhttp.use_ssl=true
    nhttp.verify_mode=OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri, {'Content-Type' => 'application/json'})

    response = nhttp.start do |http|
      http.request(request)
    end

    resp = response.body

    resp.gsub!(/[\n]/,'')
    resp.gsub!(/[\"]/,'"')

    json = resp[2,1000000000000000]
    json = json.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_')
    json = json.to_json

    hash = JSON.parse(json, :quirks_mode => true)
    hash2 = JSON.parse(hash, :quirks_mode => true)
    hh = hash2[0]

    return hh
  end

  def get_share_details
    begin
      # details = StockQuote::Stock.quote(self.code)

      # details = (details.response_code == 200) ? details : nil

      # return details

      return get_google_data(self.code)
    rescue
      puts 'Unable to get stock details'
      self.errors.add(:base, "Unable to get stock details")
      return nil
    end
  end

end
