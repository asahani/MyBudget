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

  # Master Category Reports Page data
  def master_categories_report_as_percentage
    @top_master_categories = BudgetTransaction.top_transactions_grouped_by_category(nil)
    @total_spend = BudgetTransaction.total_expenses_for_year(nil)

    @top_master_categories.map do |txn|
      {
        name: txn.name,
        expense: txn.total_expense,
        y: ((txn.total_expense/@total_spend).to_f.round(2) * 100)
      }
    end
  end

  # Category Reports Page data
  def categories_report_as_percentage
    @top_categories = BudgetTransaction.top_transactions_grouped_by_category(nil)
    @total_spend = BudgetTransaction.total_expenses_for_year(nil)

    @top_categories.map do |txn|
      {
        name: txn.name,
        expense: txn.total_expense,
        y: ((txn.total_expense/@total_spend).to_f.round(2) * 100)
      }
    end
  end
end
