require "test_helper"

class UserIsShownInNavbarTest < ActionDispatch::IntegrationTest
  test "user name shows in navbar" do
    user = create(:user)
    visit login_path

    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    within "form" do
      click_on "Login"
    end

    visit '/'
    assert page.has_content?("Logged in as #{user.first_name}")
    refute page.has_content?("Log in/Sign up")

  end

end
