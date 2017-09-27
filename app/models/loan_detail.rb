class LoanDetail
  include ActiveModel::Model

  attr_accessor :loan_account, :payee_transactions, :account_transactions, :total_balance, :total_loaned,:total_received

  def initialize(loan_account)
    @total_loaned,@total_received,@total_balance = 0
    @loan_account = loan_account
    @payee_transactions = BudgetTransaction.joins(:payee).where('payees.account_id = ?',loan_account.id)
    puts 'payee transactions = '+@payee_transactions.count.to_s
    @account_transactions = BudgetTransaction.where('account_id = ?',loan_account.id)
    puts 'account transactions = '+@account_transactions.count.to_s
    @total_loaned = BudgetTransaction.joins(:payee).where('payees.account_id = ?',loan_account.id).sum(:debit).to_f
    puts 'total loaned = '+@total_loaned.to_s
    @total_received = BudgetTransaction.joins(:payee).where('payees.account_id = ?',loan_account.id).sum(:credit).to_f
    puts 'total received = '+@total_received.to_s
    @total_balance = @total_loaned.to_f - @total_received.to_f
    puts 'total balance = '+@total_balance.to_s
  end
end
