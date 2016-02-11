require 'test_helper'

class VendorOwnerCanRemoveVendorAdminFromStoreTest < ActionDispatch::IntegrationTest
  test "vendor owner can remove vendor admin from store" do
    vendor = create(:vendor_with_user, status: 1)
    owner = vendor.users.first
    vendor.update_attributes(owner_id: owner.id)
    store_admin = create(:user, role: 1)
    store_admin.update_attributes(vendor_id: vendor.id)

    assert_equal vendor.owner_id, owner.id

    ApplicationController.any_instance.stubs(:current_user).returns(owner)

    visit vendor_dashboard_path
    click_link("Manage Store Admins")

    assert_equal vendor_users_path(vendor: vendor.url), current_path

    within("#store_admin_#{store_admin.id}") do
      click_link("Remove")
    end

    assert_equal vendor_users_path(vendor: vendor.url), current_path

    refute page.has_content?(store_admin.username)

    refute_equal vendor.id, store_admin.reload.vendor_id
    assert_equal vendor.owner_id, owner.id
    refute_equal vendor.owner_id, store_admin.id

    ApplicationController.any_instance.stubs(:current_user).returns(store_admin)

    visit vendor_dashboard_path

    refute page.has_content?(vendor.name)
    assert page.has_link?("Create Kiosk")
  end
end
