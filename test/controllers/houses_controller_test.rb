require 'test_helper'

class HousesControllerTest < ActionController::TestCase
  setup do
    @house = houses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:houses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create house" do
    assert_difference('House.count') do
      post :create, house: { address: @house.address, current_value: @house.current_value, interest_rate: @house.interest_rate, mortgage_account_id: @house.mortgage_account_id, name: @house.name, offset_account_id: @house.offset_account_id, original_balance: @house.original_balance, price_paid: @house.price_paid, purchase_date: @house.purchase_date, term_length: @house.term_length, term_start_date: @house.term_start_date }
    end

    assert_redirected_to house_path(assigns(:house))
  end

  test "should show house" do
    get :show, id: @house
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @house
    assert_response :success
  end

  test "should update house" do
    patch :update, id: @house, house: { address: @house.address, current_value: @house.current_value, interest_rate: @house.interest_rate, mortgage_account_id: @house.mortgage_account_id, name: @house.name, offset_account_id: @house.offset_account_id, original_balance: @house.original_balance, price_paid: @house.price_paid, purchase_date: @house.purchase_date, term_length: @house.term_length, term_start_date: @house.term_start_date }
    assert_redirected_to house_path(assigns(:house))
  end

  test "should destroy house" do
    assert_difference('House.count', -1) do
      delete :destroy, id: @house
    end

    assert_redirected_to houses_path
  end
end
