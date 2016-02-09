require 'test_helper'

class Vendors::OrdersControllerTest < ActionController::TestCase
  test "redirected when posting to cart" do
    post :create
    assert_redirected_to cart_path
  end
end
