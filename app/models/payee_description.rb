class PayeeDescription < ActiveRecord::Base
  ##################################
  # Relationships
  ##################################
  belongs_to :payee

  ##################################
  # Validations
  ##################################    
  validates_uniqueness_of :description
  validates_presence_of :description, :payee_id
  validates_numericality_of :payee_id, :allow_nil => false

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
