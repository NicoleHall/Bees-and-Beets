require 'test_helper'

class PlatformAdminCanSeeVendorOrdersTest < ActionDispatch::IntegrationTest
  test "platform admin can view vendors orders" do
    platform_admin = create(:platform_admin)
    vendor = create(:vendor_with_user_and_order)
    order_item = vendor.order_items.first

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit platform_dashboard_path
    
    assert page.has_content?("#{vendor.name}")

    within("#vendor-#{vendor.id}") do
      click_button("Orders")
    end

    assert_equal vendor_orders_path(vendor: vendor.url), current_path

    within("#order_item_#{order_item.id}") do
      click_link "Cancel"
    end

    within("#order_item_#{order_item.id}") do
      assert page.has_content?("Cancelled")
    end
  end
end
