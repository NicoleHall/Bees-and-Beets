require 'test_helper'

class PlatformAdminCanEditVendorTest < ActionDispatch::IntegrationTest
  test "platform admin can edit vendor" do
    platform_admin = create(:platform_admin)
    vendor = create(:vendor_with_user)

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit platform_dashboard_path
    assert page.has_content?("#{vendor.name}")
    click_button("Edit")

    assert_equal edit_vendor_path(id: vendor.id), current_path

    fill_in "Name", with: "Horace's Waffles"
    click_on "Submit"

    assert page.has_content?("Horace's Waffles")
  end
end
