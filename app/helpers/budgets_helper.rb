module BudgetsHelper
  def budget_items_chart_data
    @budget.budget_items.map do |budget_item| {
      budgeted_amount: budget_item.budgeted_amount,
      category: budget_item.category.name
    }
    end
  end

  def budget_categories_chart_data
    @budget.budget_items.collect { |budget_item| budget_item.category.name.to_s }.slice(0,5).to_json
  end

  def budget_amount_chart_data
    @budget.budget_items.collect { |budget_item| budget_item.budgeted_amount.to_f }.slice(0,5).to_json
  end

  def budget_expenses_chart_data
    @budget.budget_items.collect { |budget_item| budget_item.expenses.to_f }.slice(0,5).to_json
  end

  def budget_balance_chart_data
    @budget.budget_items.collect { |budget_item| budget_item.balance.to_f }.slice(0,5).to_json
  end

  def budget_items_chart_data
    @budget.budget_items.map do |budget_item| {
      budgeted_amount: budget_item.budgeted_amount,
      category: budget_item.category.name
    }
    end
  end
end
