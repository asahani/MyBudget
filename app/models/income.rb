class Income < ApplicationRecord
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
  after_update :delete_future_income_splits

  ##################################
  # Scoped Methods
  ##################################
  scope :active, -> { where(is_active: true)}

  ##################################
  # Class Methods
  ##################################
  def delete_future_income_splits
    future_budgets = Budget.where("start_date > ?",Date.today)
    future_budgets.each do |budget|
      splits = IncomeSplit.where("income_id = ? and budget_id = ?",self.id,budget.id).destroy_all
    end
  end

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
