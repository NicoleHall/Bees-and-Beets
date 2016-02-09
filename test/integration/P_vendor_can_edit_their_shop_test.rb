require 'test_helper'

class VendorCanEditTheirShopTest < ActionDispatch::IntegrationTest
  test "vendor can edit their shop" do
    vendor = create(:vendor_with_user, status: 1)
    user_vendor = vendor.users.first

    visit login_path

    fill_in "Username", with: user_vendor.username
    fill_in "Password", with: "password"
    within "form" do
      click_on "Login"
    end

    visit vendor_dashboard_path

    click_on "Edit Kiosk"

    assert_equal edit_vendor_path(vendor), current_path

    fill_in "Name", with: "Leornard's Potato Salad"
    fill_in "Description", with: "Complicated potato salad."
    fill_in "Image path", with: "http://images.edge-generalmills.com/6e42a6b2-18b6-46f8-b383-94e0379fb9a5.jpg"
    click_on "Submit"

    assert_equal vendor_dashboard_path, current_path
    vendor = user_vendor.reload.vendor

    within('#vendor-details') do
      assert page.has_content?("Status: #{vendor.status}")
      assert page.has_content?("Kiosk Name: #{vendor.name}")
      assert page.has_content?("Description: #{vendor.description}")
      assert page.has_link?("Edit Kiosk")
    end
  end
end
