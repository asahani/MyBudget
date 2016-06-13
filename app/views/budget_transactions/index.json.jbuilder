json.array!(@budget_transactions) do |budget_transaction|
  json.extract! budget_transaction, :id, :credit, :debit, :transaction_date, :comments, :manual, :scheduled, :budgeted, :account_id, :budget_item_id, :payee_id
  json.url budget_transaction_url(budget_transaction, format: :json)
end
