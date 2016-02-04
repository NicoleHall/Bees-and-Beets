require 'test_helper'

class GuestCanSeeIndividualCategoryTest < ActionDispatch::IntegrationTest
  test "guest sees individual category" do
    category1, category2, category3 = create_list(:category_with_items, 3)

    visit categories_path

    assert_equal Category.count, 3

    click_on category1.name

    save_and_open_page
    assert page.has_content?(category1.name)
    assert page.has_content?(category1.items.first)
    assert page.has_content?("Add to Cart")
  end
end
