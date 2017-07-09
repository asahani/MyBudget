class ReportsController < ApplicationController
  layout 'application'

  def index
    @budget_year = Date.today.year
    @annual_report = get_annual_report(@budget_year)
    @monthly_income = 0
    Income.all.active.each do |income|
      @monthly_income += income.monthly_income
    end
    @budgets_for_year  = Budget.budgets_for_year
  end

  def category_report
    @budget_year = Date.today.year
    @miscellaneous_only = false
    unless params[:miscellaneous].nil?
      @miscellaneous_only = params[:miscellaneous] == 'true'? true : false
    end
  end

  def master_category_report
    @budget_year = Date.today.year
    @miscellaneous_only = false
    unless params[:miscellaneous].nil?
      @miscellaneous_only = params[:miscellaneous] == 'true'? true : false
    end
  end

  def payee_report
    @budget_year = Date.today.year
    @miscellaneous_only = false
    unless params[:miscellaneous].nil?
      @miscellaneous_only = params[:miscellaneous] == 'true'? true : false
    end
  end

end
