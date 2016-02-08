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
    binding.pry
    assert_equal vendor, item.user

    assert_equal vendor_item_path(vendor: vendor.url, id: item.id), current_path

    assert page.has_link?("Edit Item")
    assert page.has_link?("Delete Item")
    assert page.has_content? item.title
    assert page.has_content? item.vendor.name
    assert page.has_content? item.description
    assert page.has_content? item.price
  end

  test "guest cannot add an item" do
    skip
    user = create(:user)
    store = create(:vendor_with_items, status: 1)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit vendor_items_path(vendor: store.url)
    assert page.has_content?(store.item.first.title)
    refute page.has_link?("Create Item")
  end

  test "item can have a price with commas and dollar signs" do
    skip
    vendor = create(:vendor)
    image_path = "https://petenelson.com/wp-content" \
                 "/uploads/2011/08/ron-swanson-meat.jpg"

    category = create(:category)
    ApplicationController.any_instance.stubs(:current_user).returns(vendor)

    visit vendor_dashboard_path
    click_on "Create Item"
    assert_equal vendor_items_path(vendor: vendor.url), current_path

    fill_in "Title", with: "Meat"
    fill_in "Image path", with: image_path
    fill_in "Price", with: "$100,000"
    fill_in "Description", with: "Salad? That's what my food eats"
    select category.name, from: "item_category_id"
    click_on "Create Item"

    assert_equal vendor_item_path(vendor: vendor.url, id: Item.last.id), current_path
    assert_equal 1, Item.count
    assert page.has_content? Item.last.price
    assert_equal vendor, Item.last.user
    assert_equal 100000, Item.last.price
  end

  test "vendor cannot add item with missing fields" do
    skip
    vendor = create(:vendor)
    category = create(:category)
    ApplicationController.any_instance.stubs(:current_user).returns(vendor)

    image_path = "https://petenelson.com/wp-content" \
                 "/uploads/2011/08/ron-swanson-meat.jpg"

    visit vendor_dashboard_path
    click_on "Create Item"

    assert_equal vendor_items_path(vendor: vendor.url), current_path

    fill_in "Image path", with: image_path
    fill_in "Price", with: "10"
    fill_in "Description", with: "Salad? That's what my food eats"
    select category.name, from: "item_category_id"
    click_on "Create Item"

    assert page.has_content? "Incomplete form"
    assert_equal 0, Item.count
  end
end
