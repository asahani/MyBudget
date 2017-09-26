module BudgetsHelper

  def budget_breakdown_pie_data
    total_allocated = @savings + @expenses
    total_remaining = (@income - total_allocated) > 0 ? (@income - total_allocated).to_f : 0
    total = (total_allocated + total_remaining).to_f
    misc_expenses = @budget.budget_transactions.miscellaneous_transactions.sum(:debit).to_f
    budgeted_expenses = (@expenses - misc_expenses).to_f

    data_array = Array.new
    data_array << {"name" => "Savings","y" => (@savings/total).to_f.round(2) * 100}
    data_array << {"name" => "Budgeted Expenses","y" => (budgeted_expenses/total).to_f.round(2) * 100}
    data_array << {"name" => "Misc Expenses","y" =>(misc_expenses/total).to_f.round(2) * 100}
    data_array << {"name" => "Remaining","y" =>(total_remaining/total).to_f.round(2) * 100}

    puts data_array.to_a.to_json

    return data_array.to_a.to_json
  end

  def top_spending_categories
    top_expenses = BudgetTransaction.total_miscellaneous_grouped_by_master_category(@budget.id)
    top_expenses.map do |txn|
      {
        category: txn.name,
        spend: txn.total_expense
      }
    end
  end

  def miscellaneous_categories
    top_expenses = BudgetTransaction.total_miscellaneous_grouped_by_category(@budget.id)
    top_expenses.map do |txn|
      {
        category: txn.name,
        spend: txn.total_expense
      }
    end
  end

  def miscellaneous_categories_as_percentage(limit = 10)
    expenses = BudgetTransaction.total_miscellaneous_grouped_by_category(@budget.id,limit)
    total_spend = BudgetTransaction.where(budget_id: @budget.id).miscellaneous_transactions.sum(:debit).to_f

    expenses.map do |txn|
      {
        name: txn.name,
        y: ((txn.total_expense/total_spend).to_f.round(2) * 100)
      }
    end
  end

  def top_misc_spending_master_categories_as_percentage
    top_expenses = BudgetTransaction.total_miscellaneous_grouped_by_master_category(@budget.id)
    total_spend = BudgetTransaction.where(budget_id: @budget.id).miscellaneous_transactions.sum(:debit).to_f

    top_expenses.map do |txn|
    {
      name: txn.name,
      y: ((txn.total_expense/total_spend).to_f.round(2) * 100)
    }
    end
  end

  def payee_spend(limit = 10)
    expenses = BudgetTransaction.total_grouped_by_external_payee(@budget.id,limit)
    expenses.map do |txn|
      {
        payee: txn.name,
        spend: txn.total_expense
      }
    end
  end

  def payee_spend_as_percentage(limit = 10)
    expenses = BudgetTransaction.total_grouped_by_external_payee(@budget.id,limit)
    total_spend = 0
    expenses.map do |x| total_spend = total_spend + x.total_expense end

    expenses.map do |txn|
      {
        name: txn.name,
        y: ((txn.total_expense/total_spend).to_f.round(2) * 100)
      }
    end
  end

  def budget_items_chart_data
    @budget.budget_items.map do |budget_item| {
      budgeted_amount: budget_item.budgeted_amount,
      category: budget_item.category.name
    }
    end
  end

  def budget_categories_chart_data
    @budget.budget_items.collect { |budget_item| budget_item.category.name.to_s }.to_json
  end

  def budget_amount_chart_data
    @budget.budget_items.collect { |budget_item| budget_item.budgeted_amount.to_f }.to_json
  end

  def budget_expenses_chart_data
    @budget.budget_items.collect { |budget_item| budget_item.expenses.to_f }.to_json
  end

  def budget_balance_chart_data
    @budget.budget_items.collect { |budget_item| budget_item.balance.to_f }.to_json
  end


  def get_calendar_events
    event_array = Array.new
    @budget.budget_items.each do |budget_item|
      if budget_item.category.scheduled
        event = {}
        month_due = budget_item.category.scheduled_day < Rails.application.config.start_of_the_month ? budget_item.budget.month + 1 : budget_item.budget.month
        year_due = (budget_item.category.scheduled_day < Rails.application.config.start_of_the_month) && (budget_item.budget.month == 12)? budget_item.budget.year + 1 : budget_item.budget.year
        event["month"] = month_due
        event["day"] = budget_item.category.scheduled_day
        event["year"] = year_due
        event["title"] = budget_item.category.name
        event["description"] = budget_item.category.name + " due on " + budget_item.category.scheduled_day.to_s + "." + month_due.to_s + "." + year_due.to_s

        event_array << event
      end
    end

    @budget.budget_incomes.each do |budget_income|
      unless budget_income.income.nil?
        income_splits = IncomeSplit.where("budget_id = ? and income_id = ?",budget_income.budget.id,budget_income.income.id)
        income_splits.each do |split|
          event = {}
          month_due = split.income_split_date.month
          year_due = split.income_split_date.year
          event["month"] = month_due
          event["day"] = split.income_split_date.day
          event["year"] = year_due
          event["title"] = "Income"
          event["description"] = split.income.description + " : $" + split.amount.to_s

          event_array << event
        end
      end
    end

    # event_array =
    #   [{
    #     "month"=> "10",
    #     "day"=> "12",
    #     "year"=> "2016",
    #     "title"=> "Lorem ipsum",
    #     "description"=> "Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Nullam id dolor id nibh ultricies vehicula ut id elit. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cras justo odio, dapibus ac facilisis in, egestas eget quam."
    #   },
    #   {
    #     "month"=> "10",
    #     "day"=> "9",
    #     "year"=> "2016",
    #     "title"=> "Lorem ipsum",
    #     "description"=> "Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Nullam id dolor id nibh ultricies vehicula ut id elit. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cras justo odio, dapibus ac facilisis in, egestas eget quam."
    #   },
    #   {
    #     "month"=> "10",
    #     "day"=> "10",
    #     "year"=> "2016",
    #     "title"=> "Lorem ipsum",
    #     "description"=> "Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Nullam id dolor id nibh ultricies vehicula ut id elit. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cras justo odio, dapibus ac facilisis in, egestas eget quam."
    #   }]

    return event_array.to_a.to_json
  end
end
