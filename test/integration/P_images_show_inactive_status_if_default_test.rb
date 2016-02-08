require "test_helper"

class ImagesShowInactiveStatusIfDefaultTest < ActionDispatch::IntegrationTest
  test "images default to inactive if there is no image" do
    vendor = create(:vendor_with_user, status: 1)
    user = vendor.users.first
    category = create(:category)
    image_path = "https://petenelson.com/wp-content" \
                 "/uploads/2011/08/ron-swanson-meat.jpg"
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit new_vendor_item_path(vendor: vendor.url)

    fill_in "Title", with: "Meat"
    fill_in "Price", with: "10"
    fill_in "Description", with: "Salad? That's what my food eats"
    select category.name, from: "item_category_id"
    click_on "Create Item"

    item = Item.last

    assert_equal vendor, item.vendor
    assert_equal "https://www.weefmgrenada.com/images/na4.jpg", item.image_path
    assert_equal "inactive", item.status

    click_on "Edit Item"
    choose "Active"
    click_on "Update Item"

    assert_equal "inactive", item.status

    click_on "Edit Item"
    fill_in "Image path", with: image_path
    choose "Active"
    click_on "Update Item"

    assert_equal "active", item.reload.status
  end
end
