class Goal < ApplicationRecord
  ##################################
  # Relationships
  ##################################
  belongs_to :account

  ##################################
  # Validations
  ##################################
  validates_uniqueness_of :name
  validates_presence_of :name,:icon,:account_id,:target_amount,:percentage_towards_goal,:current_balance_towards_goal
  validates_numericality_of :account_id,:target_amount,:percentage_towards_goal,:current_balance_towards_goal

  ##################################
  # Callbacks
  ##################################
  before_create :allocate_initial_funds
  before_save :update_active_status

  ##################################
  # Scoped Methods
  ##################################
  scope :active, -> { where(is_active: true)}

  ##################################
  # Class Methods
  ##################################

  def allocate_initial_funds
    self.saved_amount = self.current_balance_towards_goal
  end

  def update_active_status
    if self.saved_amount > self.target_amount
      self.is_active = false
    end
    if Date.today >= self.target_date
      self.is_active = false
    end
  end

  def expected_progress_percent
    target_days = (self.target_date - self.created_at.to_date).to_i
    elapsed_days = (Date.today-self.created_at.to_date).to_i
    target_days_percentage = ((elapsed_days.to_f/target_days.to_f) * 100).round(2)
    return target_days_percentage
  end

  def expected_progress_amount
    self.target_amount.to_f * (self.expected_progress_percent.to_f/100).round(2)
  end

  def percent_complete
    (self.saved_amount.to_f/self.target_amount.to_f).to_f.round(2)*100
  end

  def time_remaining
    (self.target_date - Date.today)/30
  end

  def amount_required_per_month
    (self.target_amount.to_f - self.saved_amount.to_f)/self.time_remaining
  end

end
