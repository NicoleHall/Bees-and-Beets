require 'test_helper'

class UserCanLogOutTest < ActionDispatch::IntegrationTest
  test "user can log out" do
    user = create(:user)

    visit login_path

    fill_in "Username", with: user.username
    fill_in "Password", with: "password"
    within "form" do
      click_button "Login"
    end

    first(:link, "Logout").click

    assert_equal current_path, root_path
    within(".nav-wrapper") do
      refute page.has_content?("Welcome, #{user.first_name}!")
    end
  end
end
