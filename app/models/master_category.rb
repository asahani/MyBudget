class MasterCategory < ActiveRecord::Base
  has_many :categories

  validates_presence_of :name
  validates_uniqueness_of :name

  ##################################
  # Scoped Methods
  ##################################
  scope :user_editable, -> { where('display = ?',true)}

end
