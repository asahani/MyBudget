class House < ActiveRecord::Base
  ##################################
  # Relationships
  ##################################
  belongs_to :mortgage_account, :class_name => 'Account', :foreign_key => 'mortgage_account_id'
  belongs_to :offset_account, :class_name => 'Account', :foreign_key => 'offset_account_id'

  ##################################
  # Validations
  ##################################
  validates_uniqueness_of :name,:address,:mortgage_account_id,:offset_account_id
  validates_presence_of :name,:address,:mortgage_account_id,:price_paid,:original_balance,:current_value,:interest_rate,:term_length,:purchase_date,:term_start_date,:monthly_payment
  validates_numericality_of :mortgage_account_id,:price_paid,:original_balance,:current_value,:interest_rate,:term_length,:monthly_payment

  ##################################
  # Callbacks
  ##################################
  after_create :update_schedule_and_debit_one_click_for_category
  after_update :update_schedule_and_debit_one_click_for_category

  ##################################
  # Scoped Methods
  ##################################


  ##################################
  # Class Methods
  ##################################


  private

  def update_schedule_and_debit_one_click_for_category
  end

end
