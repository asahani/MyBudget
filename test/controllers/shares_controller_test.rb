require 'test_helper'

class SharesControllerTest < ActionController::TestCase
  setup do
    @share = shares(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create share" do
    assert_difference('Share.count') do
      post :create, share: { brokerage_account_id: @share.brokerage_account_id, code: @share.code, last_price: @share.last_price, name: @share.name, no_cash_transaction: @share.no_cash_transaction, purchase_date: @share.purchase_date, purchase_price: @share.purchase_price, sell_date: @share.sell_date, sell_price: @share.sell_price, type: @share.type, units: @share.units }
    end

    assert_redirected_to share_path(assigns(:share))
  end

  test "should show share" do
    get :show, id: @share
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @share
    assert_response :success
  end

  test "should update share" do
    patch :update, id: @share, share: { brokerage_account_id: @share.brokerage_account_id, code: @share.code, last_price: @share.last_price, name: @share.name, no_cash_transaction: @share.no_cash_transaction, purchase_date: @share.purchase_date, purchase_price: @share.purchase_price, sell_date: @share.sell_date, sell_price: @share.sell_price, type: @share.type, units: @share.units }
    assert_redirected_to share_path(assigns(:share))
  end

  test "should destroy share" do
    assert_difference('Share.count', -1) do
      delete :destroy, id: @share
    end

    assert_redirected_to shares_path
  end
end
