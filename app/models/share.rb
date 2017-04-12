class Share < ActiveRecord::Base
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

  ##################################
  # Scoped Methods
  ##################################
  scope :active, -> { where('sell_price = ',nil)}

  ##################################
  # Class Methods
  ##################################
end
