class CartTest < ActiveSupport::TestCase
  test "has initial contents" do
    cart = Cart.new("1" => 1)

    assert_equal({ "1" => 1 }, cart.contents)
  end

  test "can add a item" do
    cart = Cart.new("1" => 1)

    cart.add_item(1)
    cart.add_item(2)

    assert_equal({ "1" => 2, "2" => 1 }, cart.contents)
  end

  test "can delete a item" do
    cart = Cart.new("1" => 2, "3" => 4)

    cart.delete_item(3)

    assert_equal({ "1" => 2 }, cart.contents)
  end

  test "returns total number of items in cart" do
    cart = Cart.new("1" => 3, "2" => 1, "3" => 2)

    assert_equal 6, cart.count
  end

  test "returns total cost of all items in cart" do
    item_1 = create(:item, price: 5.0)
    item_2 = create(:item, price: 3.0)
    item_3 = create(:item, price: 10.0)
    cart = Cart.new(item_1.id => 2, item_2.id => 3, item_3.id => 1)

    assert_equal 29.0, cart.total_price
  end
end
