json.array!(@budgets) do |budget|
  json.extract! budget, :id, :year, :month, :start_date, :end_date
  json.url budget_url(budget, format: :json)
end
