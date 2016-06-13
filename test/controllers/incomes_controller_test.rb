require 'test_helper'

class IncomesControllerTest < ActionController::TestCase
  setup do
    @income = incomes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incomes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create income" do
    assert_difference('Income.count') do
      post :create, income: { account_id: @income.account_id, amount: @income.amount, budget_id: @income.budget_id, description: @income.description, fortnightly: @income.fortnightly, monthly: @income.monthly, recurring: @income.recurring, weekly: @income.weekly }
    end

    assert_redirected_to income_path(assigns(:income))
  end

  test "should show income" do
    get :show, id: @income
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @income
    assert_response :success
  end

  test "should update income" do
    patch :update, id: @income, income: { account_id: @income.account_id, amount: @income.amount, budget_id: @income.budget_id, description: @income.description, fortnightly: @income.fortnightly, monthly: @income.monthly, recurring: @income.recurring, weekly: @income.weekly }
    assert_redirected_to income_path(assigns(:income))
  end

  test "should destroy income" do
    assert_difference('Income.count', -1) do
      delete :destroy, id: @income
    end

    assert_redirected_to incomes_path
  end
end
