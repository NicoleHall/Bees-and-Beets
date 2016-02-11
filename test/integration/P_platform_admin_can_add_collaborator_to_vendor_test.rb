require 'test_helper'

class PlatformAdminCanAddCollaboratorToVendorTest < ActionDispatch::IntegrationTest
  test "platform admin can view store admins to vendor" do
    platform_admin = create(:platform_admin)
    vendor = create(:vendor_with_user)
    user = vendor.users.first
    vendor.update_attributes(owner_id: user.id)
    default_user = create(:user)

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit platform_dashboard_path
    assert page.has_content?("#{vendor.name}")
    click_button("Store Admins")

    assert_equal vendor_users_path(vendor: vendor.url), current_path
    click_link("Add Store Admin")

    assert_equal new_vendor_user_path(vendor: vendor.url), current_path

    assert page.has_content?("Enter Username Of New Store Admin:")
    fill_in "Username", with: default_user.username
    click_button("Submit")

    assert_equal vendor_users_path(vendor: vendor.url), current_path

    assert page.has_content?(default_user.username)
    assert_equal vendor.id, default_user.reload.vendor_id
    assert_equal vendor.owner_id, user.id
    refute_equal vendor.owner_id, default_user.id
  end
end
