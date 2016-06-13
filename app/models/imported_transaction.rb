class ImportedTransaction < ActiveRecord::Base
  belongs_to :category
  belongs_to :account
  belongs_to :payee
  
  validates_numericality_of :credit, :debit, :allow_nil => true
end
