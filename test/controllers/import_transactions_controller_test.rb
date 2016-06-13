require 'test_helper'

class ImportTransactionsControllerTest < ActionController::TestCase
  test "should get open_file" do
    get :open_file
    assert_response :success
  end

  test "should get process_file" do
    get :process_file
    assert_response :success
  end

  test "should get remove" do
    get :remove
    assert_response :success
  end

  test "should get import" do
    get :import
    assert_response :success
  end

end
