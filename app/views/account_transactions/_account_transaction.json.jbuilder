json.extract! account_transaction, :id, :account_id, :payee_id, :budget_id, :category_id, :amount, :transaction_date, :comments, :reconciled, :created_at, :updated_at
json.url account_transaction_url(account_transaction, format: :json)
