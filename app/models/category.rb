class Category < ApplicationRecord
  belongs_to :master_category
  has_many :budget_items

  validates_presence_of :name, :master_category_id, :budget_amount
  validates_uniqueness_of :name

  ##################################
  # Scoped Methods
  ##################################
  scope :non_system, -> { where('active = ?',true)}
  scope :for_budget, -> { where('active = ? and budgeted = ?',true,true)}
end
