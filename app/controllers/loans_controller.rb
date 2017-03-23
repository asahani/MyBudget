class LoansController < ApplicationController
  # GET /loans
  # GET /loans.json
  def index
    @loan_accounts = Account.loan_account.all
  end
end
