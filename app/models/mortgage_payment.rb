class MortgagePayment
  include ActiveModel::Model

  attr_accessor :month, :interest_payment, :principal_payment, :balance

end
