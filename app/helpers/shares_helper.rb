module SharesHelper
  def share_price_history_data
    arr = Array.new
    @share.get_share_history.each do |price|
      date = price['Date'].to_date
      if date == Date.today
        arr << price['Close'].to_f
      elsif date.day == 15 || date.day == 1
        arr << price['Close'].to_f
      end
    end
    return arr.to_json
  end

  def shares_price_history_data
    prices = Hash.new(0)
    puts '-------------------------------------SHARES MARKET VALUE'
    Share.all.active.each do |share|
        puts share.name
        share.get_share_history.each do |price|
          date = price['Date'].to_date
          if date == Date.today - 1
            puts price['Close'].to_f
            prices[date] = prices[date] + (price['Close'].to_f * share.units)
            puts prices[date]
          elsif date.day == 15 || date.day == 1
            prices[date] = prices[date] + (price['Close'].to_f * share.units)
          end
        end
    end

    puts prices.values.to_json

    return prices.values.to_json
  end
end
