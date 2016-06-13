json.array!(@budget_incomes) do |budget_income|
  json.extract! budget_income, :id, :description, :amount, :budget_id, :account_id
  json.url budget_income_url(budget_income, format: :json)
end
