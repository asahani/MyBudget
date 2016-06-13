require 'test_helper'

class AccountTypesControllerTest < ActionController::TestCase
  setup do
    @account_type = account_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:account_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account_type" do
    assert_difference('AccountType.count') do
      post :create, account_type: { budget_account: @account_type.budget_account, type: @account_type.type }
    end

    assert_redirected_to account_type_path(assigns(:account_type))
  end

  test "should show account_type" do
    get :show, id: @account_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @account_type
    assert_response :success
  end

  test "should update account_type" do
    patch :update, id: @account_type, account_type: { budget_account: @account_type.budget_account, type: @account_type.type }
    assert_redirected_to account_type_path(assigns(:account_type))
  end

  test "should destroy account_type" do
    assert_difference('AccountType.count', -1) do
      delete :destroy, id: @account_type
    end

    assert_redirected_to account_types_path
  end
end
