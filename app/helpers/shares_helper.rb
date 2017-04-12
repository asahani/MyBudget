module SharesHelper
  def share_price_history_data
    @share.get_share_history.collect {|s| s['Close'].to_f}.to_a.to_json
  end
end
