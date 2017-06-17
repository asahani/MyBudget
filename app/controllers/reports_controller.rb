class ReportsController < ApplicationController
  layout 'application'

  def index
    @budget_year = Date.today.year
    @annual_report = get_annual_report(@budget_year)
  end

  def category_report
    @budget_year = Date.today.year
  end

  def master_category_report
    @budget_year = Date.today.year
  end
  
end
