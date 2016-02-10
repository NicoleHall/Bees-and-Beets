require 'test_helper'
class PlatformAdminCanEditAVendorsItemsTest < ActionDispatch::IntegrationTest

  test "platform admins can edit an item" do

    platform_admin = create(:user)
    platform_admin.update_attribute(:role, 2)
    vendor = create(:vendor_with_items)
    vendor.update_attribute(:status, 1)
    item1 = Item.first
    item2 = Item.last
    item1.update_attribute(:title, "Pine Cone")
    item2.update_attribute(:title, "Tuna Fish Sandwich")

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit platform_dashboard_path
    assert page.has_content?("#{vendor.name}")
    click_button("Items")

    assert_equal "", current_path


  end

end
