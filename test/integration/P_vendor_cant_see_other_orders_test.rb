require 'test_helper'

class VendorCantSeeOtherOrdersTest < ActionDispatch::IntegrationTest
  test "a vendor cant see other vendors orders" do
    vendor_1, vendor_2 = create_list(:vendor_with_user, 2)
    vendor_admin_1 = vendor_1.users.first
    vendor_admin_2 = vendor_2.users.first

    ApplicationController.any_instance.stubs(:current_user).returns(vendor_admin_1)

    visit vendor_orders_path(vendor: vendor_2.url)
    message_404 = "The page you were looking for doesn't exist (404)"
    assert page.has_content? message_404
  end
end
