module ApplicationHelper
  def goals_pie_chart_data
    total_target = @goals.sum(:target_amount)
    total_saved = @goals.sum(:saved_amount)

    goals_map = @goals.map do |goal|
      {
        name: goal.name,
        amount: goal.saved_amount,
        y: ((goal.saved_amount.to_f/total_target.to_f).to_f.round(2) * 100)
      }
    end
    goals_map << {
      name: 'Remaining',
      amount: total_target - total_saved,
      y: (((total_target - total_saved).to_f/total_target.to_f).to_f.round(2) * 100)
    }
    return goals_map
  end
end
