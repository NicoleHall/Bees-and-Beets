require 'test_helper'

class UserCanEditAnAddressTest < ActionDispatch::IntegrationTest
  test 'user can edit an address' do
    user = create(:user_with_addresses)
    address = user.addresses.first
    # ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit login_path
    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'password'
    within('form') do
      click_on 'Login'
    end

    visit addresses_path
    within("#address-#{address.label.parameterize}") do
      click_on 'Edit'
    end

    assert_equal edit_address_path(address), current_path

    fill_in 'Label', with: 'Uncle Slota'
    fill_in 'Street', with: '123 Maple Drive'
    fill_in 'City', with: 'Denver'
    fill_in 'State', with: 'CO'
    fill_in 'Zipcode', with: '80220'
    click_on 'Submit'

    assert_equal addresses_path, current_path
    address = user.addresses.first

    within("#address-#{address.label.parameterize}") do
      assert page.has_content?('Uncle Slota')
      assert page.has_content?("#{address.street}")
      assert page.has_content?("#{address.city}")
      assert page.has_content?("#{address.state}")
      assert page.has_content?("#{address.zipcode}")
    end
  end
end
