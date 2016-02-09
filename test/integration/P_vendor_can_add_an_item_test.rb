require "test_helper"

class VendorCanAddAnItemTest < ActionDispatch::IntegrationTest
  test "vendor adds an item for themselves" do
    vendor = create(:vendor_with_user, status: 1)
    user = vendor.users.first
    category = create(:category)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    image_path = "https://petenelson.com/wp-content" \
                 "/uploads/2011/08/ron-swanson-meat.jpg"

    visit vendor_dashboard_path
    click_on "View My Items"

    assert_equal vendor_items_path(vendor: vendor.url), current_path

    assert page.has_content?("Add Item")
    click_on "Add Item"
    assert_equal new_vendor_item_path(vendor: vendor.url), current_path

    fill_in "Title", with: "Meat"
    fill_in "Image path", with: image_path
    fill_in "Price", with: "10"
    fill_in "Description", with: "Salad? That's what my food eats"
    select category.name, from: "item_category_id"
    click_on "Create Item"

    item = Item.last
    assert_equal vendor, item.vendor

    assert_equal vendor_items_path(vendor: vendor.url), current_path
    assert page.has_link?("Edit Item")
    assert page.has_link?("Delete Item")
    assert page.has_content? item.title
    assert page.has_content? item.vendor.name
    assert page.has_content? item.description
    assert page.has_content? item.price
  end

  test "guest cannot add an item" do
    vendor = create(:vendor_with_items, status: 1)
    user = create(:user)

    ApplicationController.any_instance.stubs(:current_user).returns(user)
    user = create(:user)

    visit vendor_items_path(vendor: vendor.url)
    assert page.has_content?(vendor.items.first.title)
    refute page.has_link?("Add Item")
    refute page.has_button?("Edit Item")
    refute page.has_button?("Delete Item")
  end

  test "item can have a price with commas and dollar signs" do
    vendor = create(:vendor_with_user, status: 1)
    user = vendor.users.first
    category = create(:category)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    image_path = "https://petenelson.com/wp-content" \
                 "/uploads/2011/08/ron-swanson-meat.jpg"

    visit new_vendor_item_path(vendor: vendor.url)

    fill_in "Title", with: "Meat"
    fill_in "Image path", with: image_path
    fill_in "Price", with: "$100,000"
    fill_in "Description", with: "Salad? That's what my food eats"
    select category.name, from: "item_category_id"
    click_on "Create Item"

    assert_equal vendor_items_path(vendor: vendor.url), current_path
    assert_equal 3, Item.count
    assert page.has_content? Item.last.price
    assert_equal vendor, Item.last.vendor
    assert_equal 100000, Item.last.price
  end

  test "vendor cannot add item with missing fields" do
    vendor = create(:vendor_with_user, status: 1)
    user = vendor.users.first
    category = create(:category)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    image_path = "https://petenelson.com/wp-content" \
                 "/uploads/2011/08/ron-swanson-meat.jpg"

    visit new_vendor_item_path(vendor: vendor.url)

    fill_in "Image path", with: image_path
    fill_in "Price", with: "10"
    fill_in "Description", with: "Salad? That's what my food eats"
    select category.name, from: "item_category_id"
    click_on "Create Item"

    assert page.has_content? "Incomplete form"
    assert_equal 2, Item.count
  end
end
