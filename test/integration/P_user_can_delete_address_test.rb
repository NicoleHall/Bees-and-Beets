require 'test_helper'

class UserCanDeleteAddressTest < ActionDispatch::IntegrationTest
  test "user can delete an address" do
    user = create(:user_with_addresses)
    address = user.addresses.first

    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: "password"
    within("form") do
      click_on "Login"
    end

    visit addresses_path
    within("#address-#{address.label.parameterize}") do
      click_on "Delete"
    end

    assert_equal user.addresses.count, 1
    refute page.has_content?("#address.label.parameterize")
  end
end
