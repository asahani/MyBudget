class ReportsController < ApplicationController
  layout 'application'
  before_action :set_budget_year

  def index
    @annual_report = get_annual_report(@budget_year)
    @monthly_income = 0
    Income.all.active.each do |income|
      @monthly_income += income.monthly_income
    end
    @budgets_for_year  = Budget.budgets_for_year
  end

  def category_report
    @miscellaneous_only = false
    unless params[:miscellaneous].nil?
      @miscellaneous_only = params[:miscellaneous] == 'true'? true : false
    end
  end

  def master_category_report
    @miscellaneous_only = false
    unless params[:miscellaneous].nil?
      @miscellaneous_only = params[:miscellaneous] == 'true'? true : false
    end
  end

  def payee_report
    @miscellaneous_only = false
    unless params[:miscellaneous].nil?
      @miscellaneous_only = params[:miscellaneous] == 'true'? true : false
    end
  end

  def budget_expense_report
      @annual_report = get_annual_report(@budget_year)
  end

  def timeline
      limit = 500
      year = Date.today.year
      start_date = Date.new(year,1,1)
      @major_transactions = BudgetTransaction.where('transaction_date > ? and transaction_date < ? and debit >= ? and miscellaneous = ?',start_date,start_date.end_of_year,limit,true)
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_year
      @budget_year = Date.today.year
    end

end
