json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :balance
  json.url account_url(account, format: :json)
end
