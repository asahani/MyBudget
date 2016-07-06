class Category < ActiveRecord::Base
  belongs_to :master_category

  validates_presence_of :name, :master_category_id, :budget_amount
  validates_uniqueness_of :name

  ##################################
  # Scoped Methods
  ##################################
  scope :non_system, -> { where('active = ?',true)}

end
