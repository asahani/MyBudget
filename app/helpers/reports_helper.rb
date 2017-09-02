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

  def report_yearly_budgeted_amount_data
    arr = @annual_report[:yearly_budgeted_amount].slice(0,12)
    arr.collect { |yearly_budgeted_amount| yearly_budgeted_amount.to_f }.to_json
  end

  def report_income_expense_difference_data
    arr = @annual_report[:income_expense_difference].slice(0,12)
    arr.collect { |income_expense_difference| income_expense_difference.to_f }.to_json
  end

  def overall_pie_data_for_summary
    overall_map = Array.new
    overall_map << {
      name: 'Income',
      y: @annual_report[:income][12].to_f
    }
    overall_map << {
      name: 'Expenses',
      y: @annual_report[:expenses][12].to_f
    }
    overall_map << {
      name: 'Savings',
      y: @annual_report[:savings][12].to_f
    }
    return overall_map
  end


  def top_categories_as_percentage
    @top_categories = BudgetTransaction.top_transactions_grouped_by_category(limit=12,miscellaneous_only=false)
    total_spend = BudgetTransaction.total_expenses_for_year(12)

    @top_categories.map do |txn|
      {
        name: txn.name,
        expense: txn.total_expense,
        y: ((txn.total_expense/total_spend).to_f.round(2) * 100)
      }
    end
  end

  # Master Category Reports Page data
  def master_categories_report_as_percentage(miscellaneous=false)
    @top_master_categories = BudgetTransaction.top_transactions_grouped_by_master_category(limit=nil,miscellaneous_only=miscellaneous)
    if miscellaneous
      @total_spend = BudgetTransaction.total_misc_expenses_for_year(nil)
    else
      @total_spend = BudgetTransaction.total_expenses_for_year(nil)
    end

    @top_master_categories.map do |txn|
      {
        name: txn.name,
        expense: txn.total_expense,
        y: ((txn.total_expense/@total_spend).to_f.round(2) * 100)
      }
    end
  end

  # Category Reports Page data
  def categories_report_as_percentage(miscellaneous=false)
    @top_categories = BudgetTransaction.top_transactions_grouped_by_category(limit=nil,miscellaneous_only=miscellaneous)
    if miscellaneous
      @total_spend = BudgetTransaction.total_misc_expenses_for_year(nil)
    else
      @total_spend = BudgetTransaction.total_expenses_for_year(nil)
    end

    @top_categories.map do |txn|
      {
        name: txn.name,
        expense: txn.total_expense,
        y: ((txn.total_expense/@total_spend).to_f.round(2) * 100)
      }
    end
  end

  # Category Reports Page data
  def payee_report_as_percentage(miscellaneous=false)
    @top_payees = BudgetTransaction.top_transactions_grouped_by_external_payee(limit=nil,miscellaneous_only=miscellaneous)

    @total_spend = 0
    @top_payees.each do |payee|
      @total_spend += payee.total_expense
    end

    @top_payees.map do |txn|
      {
        name: txn.name,
        expense: txn.total_expense,
        y: ((txn.total_expense/@total_spend).to_f.round(2) * 100)
      }
    end
  end

  #Budget vs Expense for each Category Report
  def budget_categories_data
    # @budget.budget_items.collect { |budget_item| budget_item.category.name.to_s }.to_json
    categories = Category.for_budget.to_a
    categories << Category.find_by_name("Miscellaneous")
    return categories.collect { |category| category.name.to_s }.to_json
  end

  def budgeted_amount_data(year)
    categories = Category.for_budget.to_a
    categories << Category.find_by_name("Miscellaneous")

    return categories.collect { |category| category.budget_items.for_year(year).sum('budgeted_amount').to_f }.to_json

  end

  def budgeted_expense_data(year)
      categories = Category.for_budget.to_a
      categories << Category.find_by_name("Miscellaneous")

      return categories.collect { |category| category.budget_items.for_year(year).sum('expenses').to_f }.to_json
  end
end
