require 'test_helper'

class GuestCanSeeIndividualCategoryTest < ActionDispatch::IntegrationTest
  test "guest sees individual category" do
    category1, category2, category3 = create_list(:category_with_items, 3)

    visit categories_path

    assert_equal Category.count, 3

    click_on category1.name


    assert page.has_content?(category1.name)
    category1.items.first.each do |item|
      assert page.has_content?(item.name)
      within(".item-#{item.name}") do
        assert page.has_content?("Add to Cart")
      end
    end
  end
end
