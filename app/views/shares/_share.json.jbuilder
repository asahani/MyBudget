json.extract! share, :id, :name, :code, :type, :units, :purchase_price, :purchase_date, :last_price, :sell_price, :sell_date, :brokerage_account_id, :no_cash_transaction, :created_at, :updated_at
json.url share_url(share, format: :json)
