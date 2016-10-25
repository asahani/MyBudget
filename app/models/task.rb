class Task < ActiveRecord::Base
  ##################################
  # Relationships
  ##################################
  belongs_to :budget
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
  scope :open, -> { where(completed: false)}
  scope :low_priority, -> { where("priority = ?",3)}
  scope :normal_priority, -> { where("priority = ?",2)}
  scope :high_priority, -> { where("priority = ?",1)}

  ##################################
  # Class Methods
  ##################################

  ##################################
  # Instance Methods
  ##################################
  def agein_days
    ((Time.now - self.created_at)/60).to_i #Time lapsed in minutes
  end
end
