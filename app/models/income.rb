class Income < ActiveRecord::Base
  ##################################
  # Relationships
  ##################################
  belongs_to :account
  
  ##################################
  # Validations
  ##################################    
  validates_presence_of :description, :amount, :account_id
  validates_numericality_of :amount, :account_id

  ##################################
  # Callbacks
  ##################################
  
  ##################################
  # Scoped Methods
  ##################################
  
  ##################################
  # Class Methods
  ##################################
  
  def monthly_income
    if self.monthly
      return amount
    elsif self.fortnightly
      return (self.amount * 26)/12
    elsif self.weekly
      return (self.amount * 52)/12
    end
    return 0    
  end
  
end
