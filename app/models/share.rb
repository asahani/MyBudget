class Share < ActiveRecord::Base
  attr_accessor :share_details
  ##################################
  # Relationships
  ##################################
  belongs_to :brokerage_account, :class_name => 'Account', :foreign_key => 'brokerage_account_id'

  ##################################
  # Validations
  ##################################
  validates_presence_of :name, :code,:share_type, :units,:purchase_date,:purchase_price,:brokerage_account_id
  validates_numericality_of :units,:purchase_price,:brokerage_account_id

  ##################################
  # Callbacks
  ##################################
  # after_initialize :set_share_details
  # after_find :set_share_details

  ##################################
  # Scoped Methods
  ##################################
  scope :active, -> { where('sell_price IS NULL')}

  ##################################
  # Class Methods
  ##################################
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
    (self.last_price * self.units).to_f.round(2) unless self.last_price.nil?
  end

  def get_percent_change_value
    change_percent = self.share_details.percent_change.to_f
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
