require 'test_helper'

class UserCanAddANewAddressTest < ActionDispatch::IntegrationTest
  test "user can add a new address" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit dashboard_path
    click_on "Add Address"

    assert_equal new_address_path, current_path

    fill_in "Label", with: "Home"
    fill_in "Street", with: "123 Maple Drive"
    fill_in "City", with: "Denver"
    fill_in "State", with: "CO"
    fill_in "Zipcode", with: "80220"
    click_on "Submit"

    assert_equal addresses_path, current_path
    address = user.addresses.last

    within("#address-#{address.label}") do
      assert page.has_content?("#{address.label}")
      assert page.has_content?("#{address.street}")
      assert page.has_content?("#{address.city}")
      assert page.has_content?("#{address.state}")
      assert page.has_content?("#{address.zipcode}")
    end
  end
end
