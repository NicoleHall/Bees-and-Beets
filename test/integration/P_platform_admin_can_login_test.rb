require 'test_helper'

class PlatformAdminCanLoginTest < ActionDispatch::IntegrationTest
  test "platform admin can login" do
    platform_admin = create(:platform_admin)

    visit login_path

    fill_in "Username", with: platform_admin.username
    fill_in "Password", with: "password"
    within "form" do
      click_button "Login"
    end

    assert_equal platform_dashboard_path, current_path
    within(".nav-wrapper") do
      assert page.has_content?("Welcome, #{platform_admin.first_name}! (Admin)")
    end
  end
end
