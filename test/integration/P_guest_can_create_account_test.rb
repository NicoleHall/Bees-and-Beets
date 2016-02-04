require "test_helper"

class GuestCanCreateAccountTest < ActionDispatch::IntegrationTest
  test "guest can create account and sees profile" do
    # add_items_to_cart_and_visit_shopping_cart(1)
    # @item = @items.first
    # assert page.has_content?(@item.title)

    visit "/"
    # save_and_open_page
    first(:link, "Log In/Sign Up").click
    click_on "Create Account"

    assert_equal new_user_path, current_path

    fill_in "First name", with: "Brenna"
    fill_in "Last name", with: "Martenson"
    fill_in "Email address", with: "brenna@awesome.com"
    fill_in "Username", with: "brenna"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_on "Create Account"
    user = User.last
    assert_equal "/dashboard", current_path

    within(".nav-wrapper") do
      assert page.has_content?("Logged in as #{user.first_name}")
      refute page.has_content?("Login/Signup")
      assert page.has_content?("Logout")
    end
    assert page.has_content?("#{user.first_name}")
    assert page.has_content?("#{user.last_name}")
    assert page.has_content?("#{user.email_address}")

    assert page.has_link?("Edit Info")
    assert page.has_link?("Order History")
  end
end
