module ReportsHelper
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
end