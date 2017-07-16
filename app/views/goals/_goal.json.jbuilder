json.extract! goal, :id, :name, :icon, :amount, :target_date, :account_id, :percentage_towards_goal, :current_balance_towards_goal, :created_at, :updated_at
json.url goal_url(goal, format: :json)
