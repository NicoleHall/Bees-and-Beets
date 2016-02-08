require 'test_helper'

class OrderIsCompleteWhenAllItemsMarkedAsCompletedOrCancelledTest < ActionDispatch::IntegrationTest
  test "order is complete when all items are marked as complete or cancelled" do
    registered_user = create(:user)
    vendor_1 = create(:vendor_with_user, status: 1)
    vendor_2 = create(:vendor_with_user, status: 1)
    user_vendor_1 = vendor_1.users.first
    user_vendor_2 = vendor_2.users.first
    item_1 = vendor_1.items.first
    item_2 = vendor_1.items.last
    item_3 = vendor_2.items.first

    cart = {item_1.id => 3, item_2.id => 2, item_3.id => 4}
    order_creater = OrderCreator.new
    order = order_creater.create(registered_user, cart)

    order_item_1 = OrderItem.find_by(order_id: order.id ,item_id: item_1.id)
    order_item_2 = OrderItem.find_by(order_id: order.id ,item_id: item_2.id)
    order_item_3 = OrderItem.find_by(order_id: order.id ,item_id: item_3.id)

    ApplicationController.any_instance.stubs(:current_user).returns(user_vendor_1)
    visit vendor_orders_path(vendor: vendor_1.url)

    assert_equal "ordered", order.reload.status

    within("#order_item_#{order_item_1.id}") do
      click_on "Mark as Completed"
    end

    assert_equal "ordered", order.reload.status
    
    within("#order_item_#{order_item_2.id}") do
      click_on "Cancel"
    end

    assert_equal "ordered", order.reload.status

    ApplicationController.any_instance.stubs(:current_user).returns(user_vendor_2)
    visit vendor_orders_path(vendor: vendor_2.url)

    within("#order_item_#{order_item_3.id}") do
      click_on "Mark as Completed"
    end

    assert_equal "completed", order.reload.status
  end
end
