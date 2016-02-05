require "test_helper"

class UserCanBecomeAVendorTest < ActionDispatch::IntegrationTest
  test "registered user can become a vendor" do
  # test "registered user logs in and is taken to their dashboard" do
    user = create(:user)
    visit login_path

    fill_in "Username", with: user.username
    fill_in "Password", with: "password"
    within "form" do
      click_button "Login"
    end

    assert_equal "/dashboard", current_path
    within(".nav-wrapper") do
      assert page.has_content?("Logged in as #{user.first_name}")
    end

    refute page.has_content?("Login")
    assert page.has_content?("Logout")
  end
end
