require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "order can have multiple order items" do
    order = create(:order)
    item1 = create(:item)
    item2 = create(:item)
    order.items << item1
    order.items << item2

    assert_equal 2, order.items.count
  end

  test "order can belong to default user" do
    user = create(:user)
    order = create(:order)
    user.orders << order

    assert_equal order.user.id, user.id
  end

  test "order can belong to an vendor" do
    user_vendor = create(:user, role: 1)
    order = create(:order)
    user_vendor.orders << order

    assert_equal order.user.id, user_vendor.id
  end

  test "order can belong to an admin" do
    admin = create(:user, role: 2)
    order = create(:order)
    admin.orders << order

    assert_equal order.user.id, admin.id
  end

  test "count of ordered" do
    order_1 = create(:order, status: 0)
    order_2 = create(:order, status: 0)
    order_3 = create(:order, status: 1)

    assert_equal 2, Order.count_of_ordered
  end

  test "count of completed" do
    order_1 = create(:order, status: 0)
    order_2 = create(:order, status: 0)
    order_3 = create(:order, status: 1)

    assert_equal 1, Order.count_of_completed
  end
end
