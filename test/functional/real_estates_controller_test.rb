require 'test_helper'

class RealEstatesControllerTest < ActionController::TestCase
  setup do
    @real_estate = real_estates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:real_estates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create real_estate" do
    assert_difference('RealEstate.count') do
      post :create, real_estate: @real_estate.attributes
    end

    assert_redirected_to real_estate_path(assigns(:real_estate))
  end

  test "should show real_estate" do
    get :show, id: @real_estate.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @real_estate.to_param
    assert_response :success
  end

  test "should update real_estate" do
    put :update, id: @real_estate.to_param, real_estate: @real_estate.attributes
    assert_redirected_to real_estate_path(assigns(:real_estate))
  end

  test "should destroy real_estate" do
    assert_difference('RealEstate.count', -1) do
      delete :destroy, id: @real_estate.to_param
    end

    assert_redirected_to real_estates_path
  end
end
