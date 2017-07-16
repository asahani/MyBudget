class LoansController < ApplicationController
  # GET /loans
  # GET /loans.json
  def index
    @loan_accounts_with_details = Array.new
    # @loan_accounts = Account.loan_account.all

    Account.loan_account.all.each do |loan_account|
      @loan_accounts_with_details << LoanDetail.new(loan_account)
    end
  end
end
