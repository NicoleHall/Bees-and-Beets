require 'test_helper'

class AdminCanEditUserProfileTest < ActionDispatch::IntegrationTest
  test "platform admins can edit user profiles and view order history" do
    admin = create(:user, role: 2)
    user = create(:user)

    visit dashboard_path(user: user.slug)
    click_on "Edit Info"

    fill_in "First Name", with: "Joshua"
    assert page.has_content?("Joshua")

    click_on "Order History"
    assert page.has_content?("Order For: #{user.first_name} #{user.last_name}")
  end
end
