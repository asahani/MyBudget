module HousesHelper

  def mortgage_payments_data
    get_mortgage_payment_data_for_graph(@house.get_mortgage_payments((@house.current_balance.to_f).to_f,0))
  end

  def mortgage_with_offset_payments_data
    get_mortgage_payment_data_for_graph(@house.get_mortgage_payments((@house.current_balance.to_f).to_f,@house.offset_account.balance.to_f))
  end

  private

  def get_mortgage_payment_data_for_graph(payments)
    mortgage_arr =  Array.new
    payments.each do |mortgage_payment|
      if mortgage_payment.month % 12 == 0
        mortgage_arr << mortgage_payment
      end
    end

    mortgage_arr.collect  { |mortgage_payment| mortgage_payment.balance.to_f.round(2) }.to_a.to_json
  end
end
