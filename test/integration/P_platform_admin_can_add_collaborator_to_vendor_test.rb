require 'test_helper'

class PlatformAdminCanAddCollaboratorToVendorTest < ActionDispatch::IntegrationTest
  test "platform admin can view collaborator to vendor" do
    platform_admin = create(:platform_admin)
    vendor = create(:vendor_with_user)

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit platform_dashboard_path
    assert page.has_content?("#{vendor.name}")
    click_button("Store Admins")

    assert_equal vendor_users_path(vendor: vendor.url), current_path
  end
end
