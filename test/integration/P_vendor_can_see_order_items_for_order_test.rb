require 'test_helper'

class VendorCanSeeOrderItemsForOrderTest < ActionDispatch::IntegrationTest
  test "vendor can see order items for order" do
    registered_user = create(:user)
    vendor_1 = create(:vendor_with_user, status: 1)
    vendor_2 = create(:vendor_with_items, status: 1)
    user_vendor = vendor_1.users.first
    item_1 = vendor_1.items.first
    item_2 = vendor_1.items.last
    item_3 = vendor_2.items.first

    cart = {item_1.id => 3, item_2.id => 2, item_3.id => 4}
    order_creater = OrderCreator.new
    order = order_creater.create(registered_user, cart)

    order_item_1 = OrderItem.find_by(order_id: order.id ,item_id: item_1.id)
    order_item_2 = OrderItem.find_by(order_id: order.id ,item_id: item_2.id)

    ApplicationController.any_instance.stubs(:current_user).returns(user_vendor)

    visit vendor_orders_path(vendor: vendor_1.url)

    within("#order_item_#{order_item_1.id}") do
      click_on "#{order_item_1.order.id}"
    end

    assert_equal vendor_order_path(vendor: vendor_1.url, id: order_item_1.order.id), current_path

    assert page.has_content?("Order ID: #{order_item_1.order.id}")

    [order_item_1, order_item_2].each do |order_item|
      within("#order_item_#{order_item.id}") do
        assert page.has_content?(order_item.order.id)
        assert page.has_content?(order_item.item.title)
        assert page.has_content?(order_item.item.price)
        assert page.has_content?(order_item.quantity)
        assert page.has_content?("Ordered")
        assert page.has_link?("Mark as Completed")
        assert page.has_link?("Cancel")
      end
    end

    assert page.has_content?("Total:")
    assert page.has_content?("#{order_item_1.item.price * order_item_1.quantity + order_item_2.item.price * order_item_2.quantity}")
  end
end
