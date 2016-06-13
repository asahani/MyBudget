class IncomeSplit < ActiveRecord::Base
  ##################################
  # Relationships
  ##################################
  belongs_to :income
  belongs_to :budget
  
  ##################################
  # Validations
  ##################################    
  validates_numericality_of :amount, :total_received

  ##################################
  # Callbacks
  ##################################

  ##################################
  # Scoped Methods
  ##################################

  ##################################
  # Class Methods
  ##################################
end
