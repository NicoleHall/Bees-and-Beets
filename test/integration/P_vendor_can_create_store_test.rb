require 'test_helper'

class VendorCanCreateStoreTest < ActionDispatch::IntegrationTest
  test "a vendor can create a new store" do
    visit new_user_path

    fill_in "First name", with: "Brenna"
    fill_in "Last name", with: "Martenson"
    fill_in "Email address", with: "brenna@awesome.com"
    fill_in "Username", with: "brenna"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    select('vendor', from: 'user_role')

    click_on "Submit"
    user = User.last
    assert_equal "/vendor_dashboard", current_path

    within(".nav-wrapper") do
      assert page.has_content?("Logged in as #{user.first_name}: Vendor")
      refute page.has_content?("Login/Signup")
      assert page.has_content?("Logout")
    end

    assert page.has_content?("#{user.first_name}")
    assert page.has_content?("#{user.last_name}")
    assert page.has_content?("#{user.email_address}")

    assert page.has_link?("Edit Info")
    assert page.has_link?("Order History")
    assert page.has_link?("Create Kiosk")
  end
end
