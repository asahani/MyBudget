require 'test_helper'

class BudgetIncomesControllerTest < ActionController::TestCase
  setup do
    @budget_income = budget_incomes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:budget_incomes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create budget_income" do
    assert_difference('BudgetIncome.count') do
      post :create, budget_income: { account_id: @budget_income.account_id, amount: @budget_income.amount, budget_id: @budget_income.budget_id, description: @budget_income.description }
    end

    assert_redirected_to budget_income_path(assigns(:budget_income))
  end

  test "should show budget_income" do
    get :show, id: @budget_income
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @budget_income
    assert_response :success
  end

  test "should update budget_income" do
    patch :update, id: @budget_income, budget_income: { account_id: @budget_income.account_id, amount: @budget_income.amount, budget_id: @budget_income.budget_id, description: @budget_income.description }
    assert_redirected_to budget_income_path(assigns(:budget_income))
  end

  test "should destroy budget_income" do
    assert_difference('BudgetIncome.count', -1) do
      delete :destroy, id: @budget_income
    end

    assert_redirected_to budget_incomes_path
  end
end
