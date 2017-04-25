class ImportedTransaction < ActiveRecord::Base
  belongs_to :category
  belongs_to :account
  belongs_to :payee

  validates_presence_of :budget_id
  validates_numericality_of :budget_id
  validates_numericality_of :credit, :debit, :allow_nil => true
end
