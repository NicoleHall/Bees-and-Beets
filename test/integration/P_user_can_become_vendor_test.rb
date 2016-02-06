require "test_helper"

class UserCanBecomeAVendorTest < ActionDispatch::IntegrationTest
  test "registered user can become a vendor" do
    user = create(:user)
    visit login_path

    fill_in "Username", with: user.username
    fill_in "Password", with: "password"
    within "form" do
      click_button "Login"
    end

    assert_equal "/dashboard", current_path
    #putting this putton on shared/_user.info.html.erb
    assert page.has_button?("Become Vendor")
    click_button "Become Vendor"
    assert_equal "vendor", user.roles
  end

end
