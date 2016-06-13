json.array!(@categories) do |category|
  json.extract! category, :id, :name, :active, :budget_amount
  json.url category_url(category, format: :json)
end
