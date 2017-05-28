class DashboardController < ApplicationController
  layout "dashboard"

  def index
    @budget_year = Date.today.year
    @annual_report = get_annual_report(@budget_year)
    @goals = Goal.all.active
    @budget = Budget.where('start_date <= ? and end_date >= ?',Date.today,Date.today).first
  end
end
