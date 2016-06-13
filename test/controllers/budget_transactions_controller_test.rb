require 'test_helper'

class BudgetTransactionsControllerTest < ActionController::TestCase
  setup do
    @budget_transaction = budget_transactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:budget_transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create budget_transaction" do
    assert_difference('BudgetTransaction.count') do
      post :create, budget_transaction: { account_id: @budget_transaction.account_id, budget_item_id: @budget_transaction.budget_item_id, budgeted: @budget_transaction.budgeted, comments: @budget_transaction.comments, credit: @budget_transaction.credit, debit: @budget_transaction.debit, manual: @budget_transaction.manual, payee_id: @budget_transaction.payee_id, scheduled: @budget_transaction.scheduled, transaction_date: @budget_transaction.transaction_date }
    end

    assert_redirected_to budget_transaction_path(assigns(:budget_transaction))
  end

  test "should show budget_transaction" do
    get :show, id: @budget_transaction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @budget_transaction
    assert_response :success
  end

  test "should update budget_transaction" do
    patch :update, id: @budget_transaction, budget_transaction: { account_id: @budget_transaction.account_id, budget_item_id: @budget_transaction.budget_item_id, budgeted: @budget_transaction.budgeted, comments: @budget_transaction.comments, credit: @budget_transaction.credit, debit: @budget_transaction.debit, manual: @budget_transaction.manual, payee_id: @budget_transaction.payee_id, scheduled: @budget_transaction.scheduled, transaction_date: @budget_transaction.transaction_date }
    assert_redirected_to budget_transaction_path(assigns(:budget_transaction))
  end

  test "should destroy budget_transaction" do
    assert_difference('BudgetTransaction.count', -1) do
      delete :destroy, id: @budget_transaction
    end

    assert_redirected_to budget_transactions_path
  end
end
