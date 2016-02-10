require "test_helper"

class ViewingAdminDashboardTest < ActionDispatch::IntegrationTest
  test "registered admin can view the admin dashboard when logged in" do
    admin = create(:user, role: 2)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit platform_dashboard_path
    assert page.has_content?("Platform Dashboard")
  end

  test "registered user cannot view the admin dashboard when logged in" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit platform_dashboard_path
    assert_equal root_path, current_path
    save_and_open_page
    assert page.has_content?("You are neither a Bee nor a Beet!")
  end

  test "unregistered user cannot view the admin dashboard" do
    visit platform_dashboard_path
    assert_equal root_path, current_path
    assert page.has_content?("You are neither a Bee nor a Beet!")
  end
end
