require 'test_helper'

class VendorCanCreateStoreTest < ActionDispatch::IntegrationTest
  test "vendor can create a store" do
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
    click_on "Submit"

    assert_equal vendor_dashboard_path, current_path
    vendor = user.reload.vendor

    assert page.has_content?("Your kiosk is pending approval.")
    within('#vendor-details') do
      assert page.has_link?("View My Items")
      assert page.has_content?("Status: #{vendor.status.capitalize}")
      assert page.has_content?("Kiosk Name: #{vendor.name}")
      assert page.has_content?("Description: #{vendor.description}")
      assert page.has_link?("Edit Kiosk")
    end
  end

  test "vendor cannot create a store with invalid attributes" do
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

    fill_in "Name", with: ""
    fill_in "Description", with: "Complicated potato salad."
    fill_in "Image path", with: "http://images.edge-generalmills.com/6e42a6b2-18b6-46f8-b383-94e0379fb9a5.jpg"
    click_on "Submit"

    assert_equal new_vendor_path, current_path    
  end
end
