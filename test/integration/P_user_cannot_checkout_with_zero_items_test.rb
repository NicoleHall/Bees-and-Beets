require "test_helper"

class UserCannotCheckoutWithZeroItemsTest < ActionDispatch::IntegrationTest
  test "no order is placed and user stays on cart page" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit cart_path
    click_on "Checkout"
    
    assert_equal cart_path, current_path
    assert_equal 0, Order.count
  end
end
