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

  def get_calendar_events
    event_array =
      [{
        "month"=> "10",
        "day"=> "12",
        "year"=> "2016",
        "title"=> "Lorem ipsum",
        "description"=> "Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Nullam id dolor id nibh ultricies vehicula ut id elit. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cras justo odio, dapibus ac facilisis in, egestas eget quam."
      },
      {
        "month"=> "10",
        "day"=> "9",
        "year"=> "2016",
        "title"=> "Lorem ipsum",
        "description"=> "Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Nullam id dolor id nibh ultricies vehicula ut id elit. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cras justo odio, dapibus ac facilisis in, egestas eget quam."
      },
      {
        "month"=> "10",
        "day"=> "10",
        "year"=> "2016",
        "title"=> "Lorem ipsum",
        "description"=> "Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Nullam id dolor id nibh ultricies vehicula ut id elit. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cras justo odio, dapibus ac facilisis in, egestas eget quam."
      }]

    return event_array.to_a.to_json
  end
end
