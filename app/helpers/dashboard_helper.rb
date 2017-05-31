module DashboardHelper
  def report_months_data
    @annual_report[:month_name].collect { |month| month.to_s }.to_json
  end

  def overall_summary_report_incomes_data
    arr = @annual_report[:income].slice(0,12)
    arr.collect { |income| income.to_f }.to_json
  end

  def overall_summary_report_expenses_data
    arr = @annual_report[:total_expenses].slice(0,12)
    arr.collect { |total_expense| total_expense.to_f }.to_json
  end

  def overall_summary_report_savings_data
    arr = @annual_report[:overall_savings].slice(0,12)
    arr.collect { |overall_saving| overall_saving.to_f }.to_json
  end

  def report_expenses_data
    arr = @annual_report[:expenses].slice(0,12)
    arr.collect { |expense| expense.to_f }.to_json
  end

  def report_savings_data
    arr = @annual_report[:savings].slice(0,12)
    arr.collect { |saving| saving.to_f }.to_json
  end

  def report_yearly_budgeted_amount_data
    arr = @annual_report[:yearly_budgeted_amount].slice(0,12)
    arr.collect { |yearly_budgeted_amount| yearly_budgeted_amount.to_f }.to_json
  end

  def top_categories_as_percentage
    @top_categories = BudgetTransaction.top_transactions_grouped_by_category
    total_spend = BudgetTransaction.total_expenses_for_year

    @top_categories.map do |txn|
      {
        name: txn.name,
        expense: txn.total_expense,
        y: ((txn.total_expense/total_spend).to_f.round(2) * 100)
      }
    end
  end

end
