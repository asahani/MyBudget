class ReportsController < ApplicationController
  def index
    @budget_year = Date.today.year
    @annual_report = get_annual_report(@budget_year)
  end

end
