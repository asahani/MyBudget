class DashboardController < ApplicationController
  layout "dashboard"

  def index
    @budget_year = Date.today.year
    @annual_report = get_annual_report(@budget_year)
    @goals = Goal.all.active
    @budget = Budget.where('start_date <= ? and end_date >= ?',Date.today,Date.today).first
    @budget_consumption = 0
    unless @budget.nil?
      @budget_consumption = @budget.budget_consumption_percentage
    end
    puts 'Budget Consumption = '
    puts @budget_consumption

    @monthly_income = 0
    Income.all.active.each do |income|
      @monthly_income += income.monthly_income
    end
    @budgets_for_year  = Budget.where('year = ?',@budget_year).all.count()
  end
end
