require 'test_helper'
class AdminApprovesPendingStoreTest < ActionDispatch::IntegrationTest
  test "an admin must approve pending stores for activation" do
    user = create(:user, role: 1)
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    within "form" do
      click_on "Login"
    end
    visit vendor_dashboard_path
    click_on "Create Kiosk"
    assert_equal new_vendor_path, current_path
    fill_in "Name", with: "Leornard's Potato Salad"
    fill_in "Description", with: "Complicated potato salad."
    fill_in "Image path", with: "http://images.edge-generalmills.com/6e42a6b2-18b6-46f8-b383-94e0379fb9a5.jpg"
    click_on "Create Kiosk"
    vendor = user.reload.vendor
    admin = create(:user, role: 2)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit '/platform_dashboard'
    within('.nav-wrapper') do
      assert page.has_content?("Stores Pending Approval")
    end
    within("#vendor-#{vendor.id}") do
      assert page.has_content?("Pending")
      assert page.has_button?("Open")
      click_on "Open"
    end
    within('.nav-wrapper') do
      refute page.has_content?("Stores Pending Approval")
    end
    within("#vendor-#{vendor.id}") do
      refute page.has_content?("Pending")
      assert page.has_content?("Open")
    end
  end
end
