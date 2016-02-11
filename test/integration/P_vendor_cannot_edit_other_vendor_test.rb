require 'test_helper'

class VendorCannotEditOtherVendorTest < ActionDispatch::IntegrationTest
  test "vendor cannot edit another vendor" do
    vendor_1, vendor_2 = create_list(:vendor_with_user, 2)
    vendor_admin_1 = vendor_1.users.first
    vendor_admin_2 = vendor_2.users.first

    ApplicationController.any_instance.stubs(:current_user).returns(vendor_admin_1)

    visit edit_vendor_path(id: vendor_2.id)
    message_404 = "The page you were looking for doesn't exist (404)"
    assert page.has_content? message_404
  end
end
