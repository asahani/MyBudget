class Payee < ActiveRecord::Base
  attr_accessor :called_from_import_txn

  ##################################
  # Relationships
  ##################################
  has_many :budget_transactions
  belongs_to :category
  belongs_to :account
  has_many :payee_descriptions

  ##################################
  # Validations
  ##################################
  validates_uniqueness_of :name
  validates_uniqueness_of :account_id, :allow_nil => true
  validates_presence_of :name, :description, :category_id
  validates_presence_of :account_id, if: :is_account?
  validates_numericality_of :account_id, :allow_nil => true

  ##################################
  # Callbacks
  ##################################

  ##################################
  # Scoped Methods
  ##################################
  scope :external_payees, -> { where('is_system = ? && is_account = ?',false,false)}
  scope :all_account_payees, -> { where('is_system = ? && is_account = ?',false,true)}
  scope :account_payees, -> { joins(:account).where('is_account = ? AND accounts.is_active = ? AND accounts.budget_account = ?',true,true,true)}
  scope :loan_account_payees, -> { joins(account: :account_type).where('is_account = ? AND accounts.is_active = ? AND account_types.name = ?',true,true,"Loan")}

  scope :system_payees, -> { where(is_system: true)}
  scope :non_system, -> { where(is_system: false)}

  ##################################
  # Class Methods
  ##################################
end
