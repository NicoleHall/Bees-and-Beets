require "test_helper"

class UserChecksOutFromCartTest < ActionDispatch::IntegrationTest
  test "user is asked to log in then order is placed" do
    user = create(:user)
    add_items_to_cart_and_visit_shopping_cart(2)

    visit cart_path

    click_button "Login To Complete Order"

    assert_equal login_path, current_path

    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    within "form" do
      click_button "Login"
    end

    StripeMock.start
    Stripe::Customer.create(
      email: user.email_address,
      card: "4242424242424242"
    )

    visit cart_path
    select("Home", from: "Address List")

    click_button "Checkout"


    assert_equal 1, Order.count

    assert_equal user_orders_path(user), current_path

    assert page.has_content?("Order was successfully placed")
    assert page.has_content?(@items.first.title)
    assert page.has_content?(@items.last.title)
    assert page.has_content?(Order.last.id)
    assert page.has_content?(Order.last.total)
  end

  test "logged in user places order" do
    add_items_to_cart_and_visit_shopping_cart(2)
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    StripeMock.start
    Stripe::Customer.create(
      email: user.email_address,
      card: "4242424242424242"
    )

    visit cart_path
    select("Home", from: "Address List")

    click_button "Checkout"

    assert_equal 1, Order.count

    assert_equal user_orders_path(user), current_path

    assert page.has_content?("Order was successfully placed")
    assert page.has_content?(@items.first.title)
    assert page.has_content?(@items.last.title)
    assert page.has_content?(Order.last.id)
    assert page.has_content?(Order.last.total)
  end
end
