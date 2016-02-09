require "test_helper"

class VendorCanEditAnExistingItemTest < ActionDispatch::IntegrationTest
  test "vendor edits an existing item from vendor item index" do
    vendor = create(:vendor_with_user, status: 1)
    user = vendor.users.first
    item = vendor.items.first
    assert user.vendor?
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit vendor_items_path(vendor: vendor.url)

    within("#vendor_item_#{item.id}") do
      click_on "Edit Item"
    end

    assert_equal edit_vendor_item_path(vendor: vendor.url, id: item.id), current_path

    fill_in "Title", with: "New Title"
    click_on "Update Item"

    assert_equal vendor_items_path(vendor: vendor.url), current_path
    assert page.has_content? "New Title"
  end

  test "vendor edits an existing item from item show page" do
    vendor = create(:vendor_with_user, status: 1)
    user = vendor.users.first
    item = vendor.items.first
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit vendor_item_path(vendor: vendor.url, id: item.id)
    click_on "Edit Item"

    fill_in "Title", with: "New Item Title"
    click_on "Update Item"

    assert_equal vendor_items_path(vendor: vendor.url), current_path
    within("#vendor_item_#{item.id}") do
      assert page.has_content? "New Item Title"
    end
  end

  test "vendor cannot edit another vendor's item from item show page" do
    vendor_1 = create(:vendor_with_user, status: 1)
    user_1 = vendor_1.users.first
    item_1 = vendor_1.items.first
    ApplicationController.any_instance.stubs(:current_user).returns(user_1)

    vendor_2 = create(:vendor_with_user, status: 1)
    user_2 = vendor_2.users.last
    item_2 = vendor_2.items.first

    visit vendor_item_path(vendor: vendor_2.url, id: item_2.id)
    refute page.has_content? "Edit"
  end

  test "vendor cannot edit another vendors item from item index page" do
    vendor_1 = create(:vendor_with_user, status: 1)
    user_1 = vendor_1.users.first
    item_1 = vendor_1.items.first
    ApplicationController.any_instance.stubs(:current_user).returns(user_1)

    vendor_2 = create(:vendor_with_user, status: 1)
    user_2 = vendor_2.users.last
    item_2 = vendor_2.items.first

    visit vendor_items_path(vendor: vendor_2.url)
    refute page.has_content? "Edit"
  end

  test "vendor cannot go directly to another vendor's edit item page" do
    vendor_1 = create(:vendor_with_user, status: 1)
    user_1 = vendor_1.users.first
    item_1 = vendor_1.items.first

    ApplicationController.any_instance.stubs(:current_user).returns(user_1)

    vendor_2 = create(:vendor_with_user, status: 1)
    user_2 = vendor_2.users.last
    item_2 = vendor_2.items.first

    visit edit_vendor_item_path(vendor: vendor_2.url, id: item_2.id)
    message_404 = "The page you were looking for doesn't exist (404)"
    assert page.has_content?(message_404)
  end

  test "vendor cannot leave required fields blank when editing an item" do
    vendor = create(:vendor_with_user, status: 1)
    user = vendor.users.first
    item = vendor.items.first

    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit vendor_item_path(vendor: vendor.url, id: item.id)
    click_on "Edit Item"

    fill_in "Title", with: ""
    click_on "Update Item"

    assert page.has_content? "All fields must be filled in."
  end
end
