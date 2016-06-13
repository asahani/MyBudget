require 'test_helper'

class MasterCategoriesControllerTest < ActionController::TestCase
  setup do
    @master_category = master_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:master_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create master_category" do
    assert_difference('MasterCategory.count') do
      post :create, master_category: { active: @master_category.active, name: @master_category.name }
    end

    assert_redirected_to master_category_path(assigns(:master_category))
  end

  test "should show master_category" do
    get :show, id: @master_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @master_category
    assert_response :success
  end

  test "should update master_category" do
    patch :update, id: @master_category, master_category: { active: @master_category.active, name: @master_category.name }
    assert_redirected_to master_category_path(assigns(:master_category))
  end

  test "should destroy master_category" do
    assert_difference('MasterCategory.count', -1) do
      delete :destroy, id: @master_category
    end

    assert_redirected_to master_categories_path
  end
end
