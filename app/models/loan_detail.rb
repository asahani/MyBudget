class LoanDetail
  include ActiveModel::Model

  attr_accessor :loan_account, :payee_transactions, :account_transactions, :total_balance, :total_loaned,:total_received

  def initialize(loan_account)
    @total_loaned,@total_received,@total_balance = 0
    @loan_account = loan_account
    @payee_transactions = AccountTransaction.joins(:payee).where('payees.account_id = ?',loan_account.id)
    @account_transactions = AccountTransaction.where('account_id = ?',loan_account.id)
    @total_loaned = AccountTransaction.joins(:payee).where('payees.account_id = ?',loan_account.id).sum(:amount).to_f
    @total_received = AccountTransaction.where('account_id = ?',loan_account.id).sum(:amount).to_f
    @total_balance = @total_loaned.to_f - @total_received.to_f
  end
end
