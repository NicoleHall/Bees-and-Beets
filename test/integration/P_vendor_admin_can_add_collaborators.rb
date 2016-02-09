require 'test_helper'

class TestVendorUserCanAddCollaborators < ActionDispatch::IntegrationTest

  test "vendor user admin can add collaborators " do

      vendor = create(:vendor_with_user, status: 1)
      user = vendor.users.first
      category = create(:category)
      ApplicationController.any_instance.stubs(:current_user).returns(user)

      image_path = "https://petenelson.com/wp-content" \
                   "/uploads/2011/08/ron-swanson-meat.jpg"

      default_user = create(:user)

      assert_equal "vendor", user.role


      visit vendor_dashboard_path
      assert page.has_link?("Manage Collaborators")

      click_link("Manage Collaborators")

      assert_equal vendor_collaborators_path(vendor: vendor.url), current_path
      click_button("Add Collaborator")

      assert_equal new_vendor_collaborator_path, current_path

      assert page.has_content?("Enter Username Of New Collaborator")
      fill_in "Username", with: default_user.username
      click_button("Submit")

      assert_equal "collaborator", default_user.role
      assert_equal vendor_collaborators_path, current_path

      assert page.has_content?(default_user.username)

  end

end
