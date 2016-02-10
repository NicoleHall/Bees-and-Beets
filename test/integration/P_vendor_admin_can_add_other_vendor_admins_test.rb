require 'test_helper'

class VendorAdminCanAddOtherVendorAdminsTest < ActionDispatch::IntegrationTest
  test "vendor user admin can make another user a collaborator" do
    vendor = create(:vendor_with_user, status: 1)
    user = vendor.users.first

    assert_equal vendor.owner_id, user.id

    ApplicationController.any_instance.stubs(:current_user).returns(user)

    default_user = create(:user)

    assert_nil default_user.vendor

    visit vendor_dashboard_path
    click_link("Manage Store Admins")

    assert_equal vendor_users_path(vendor: vendor.url), current_path
    click_link("Add Store Admin")

    assert_equal new_vendor_user_path(vendor: vendor.url), current_path

    assert page.has_content?("Enter Username Of New Collaborator:")
    fill_in "Username", with: default_user.username
    click_button("Submit")

    assert_equal vendor_users_path(vendor: vendor.url), current_path

    assert page.has_content?(default_user.username)
    assert_equal vendor, default_user.vendor
    assert_equal vendor.owner_id, user.id
    refute_equal vendor.owner_id, default_user.id
  end
end
