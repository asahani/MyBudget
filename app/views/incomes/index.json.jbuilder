json.array!(@incomes) do |income|
  json.extract! income, :id, :description, :amount, :recurring, :weekly, :fortnightly, :monthly, :budget_id, :account_id
  json.url income_url(income, format: :json)
end
