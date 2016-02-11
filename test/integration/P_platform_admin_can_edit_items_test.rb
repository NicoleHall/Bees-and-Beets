require 'test_helper'
class PlatformAdminCanEditAVendorsItemsTest < ActionDispatch::IntegrationTest

  test "platform admins can edit an item" do

    platform_admin = create(:user)
    platform_admin.update_attribute(:role, 2)
    vendor = create(:vendor_with_user)
    item1 = vendor.items.first
    item1.update_attribute(:title, "Pinecone")

    ApplicationController.any_instance.stubs(:current_user).returns(platform_admin)

    visit platform_dashboard_path
    assert page.has_content?("#{vendor.name}")
    click_button("Items")

    assert_equal vendor_items_path(vendor: vendor.url), current_path

    assert page.has_content?("Pinecone")
    assert page.has_link?("Edit Item")

    within(".item-#{item1.title.parameterize}") do
      click_link "Edit"
    end

    assert_equal edit_vendor_item_path(vendor: vendor.url, id: item1.id), current_path

    fill_in "Title", with: "Waffles"
    click_on "Update Item"

    assert page.has_content?("Waffles")
  end
end
