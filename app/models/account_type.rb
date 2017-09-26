class AccountType < ApplicationRecord
  ##################################
  # Relationships
  ##################################
  has_many :accounts

  ##################################
  # Validations
  ##################################
  validates_uniqueness_of :name
  validates_presence_of :name

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
