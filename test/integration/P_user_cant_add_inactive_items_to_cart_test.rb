require "test_helper"

class UserCantAddInactiveItemsToCartTest < ActionDispatch::IntegrationTest
  test "user can view inactive item but cannot add to cart" do
    user = create(:user)
    item = create(:item, status: 0)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit vendor_item_path(vendor: item.vendor.url, id: item.id)

    refute page.has_content? "Add to Cart"
    assert page.has_content? "This item is inactive."
  end
end
