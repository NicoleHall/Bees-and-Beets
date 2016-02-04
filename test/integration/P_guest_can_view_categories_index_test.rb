require 'test_helper'

class GuestCanViewCategoriesIndexTest < ActionDispatch::IntegrationTest
  test "guest can view categories index" do
    category1, category2, category3 = create_list(:category_with_items, 3)

    visit '/'
    click_on "Shop Categories"

    assert_equal categories_path, current_path
    assert page.has_link?(category1.name)
    assert page.has_link?(category2.name)
    assert page.has_link?(category3.name)
  end
end
