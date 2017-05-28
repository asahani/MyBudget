class DashboardController < ApplicationController
  layout "dashboard"

  def index
    @budget_year = 2016#Date.today.year
    @annual_report = get_annual_report(@budget_year)
    @goals = Goal.all.active
  end
end
