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

  test "order can belong to an artist" do
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
end
