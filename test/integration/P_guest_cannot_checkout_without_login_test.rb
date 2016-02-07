require 'test_helper'

class GuestCannotCheckoutWithoutLoginTest < ActionDispatch::IntegrationTest
  test "guest must log in to checkout" do
    category = create(:category_with_items)
    items = category.items

    visit category_items_path(category_url: category.url)

    first(:button, "Add to Cart").click
    assert page.has_content?("You added #{items.first.title} to your cart.")
    cart_items = [items.first]

    vendor = create(:vendor_with_items)
    vendor_items = vendor.items
    visit vendor_items_path(vendor: vendor.url)
    item = vendor_items.last

    click_on item.title
    assert_equal vendor_item_path(vendor: vendor.url, id: item.id), current_path

    click_button "Add to Cart"
    assert page.has_content?("You added #{item.title} to your cart.")
    cart_items << item

    find("#shopping_cart").click

    assert_equal cart_path, current_path
    cart_items.each do |item|
      assert page.has_content?(item.title)
      assert page.has_content?(item.description)
      assert page.has_content?(item.price)
      assert page.has_css?("img[src*='#{item.image_path}']")
    end

    refute page.has_button?("Checkout")
    assert page.has_button?("Login To Complete Order")

  end
end
