class Task < ActiveRecord::Base
  ##################################
  # Relationships
  ##################################

  ##################################
  # Validations
  ##################################
  validates_presence_of :title
  validates_numericality_of :priority, :allow_nil => true
  validates_numericality_of :budget_id, :allow_nil => true

  ##################################
  # Callbacks
  ##################################

  ##################################
  # Scoped Methods
  ##################################

  ##################################
  # Class Methods
  ##################################

  ##################################
  # Instance Methods
  ##################################
  def age
    Time.now.to_date - self.created_at.to_date
  end
end
