require 'test_helper'

class GuestCanViewIndividualItemTest < ActionDispatch::IntegrationTest
  test "users sees individual item" do
    vendor = create(:vendor_with_items)
    item = vendor.items.first
    item2 = vendor.items.last

    visit vendor_item_path(vendor: vendor.url, id: item.id)

    assert page.has_content?(item.title)
    assert page.has_content?(item.description)
    assert page.has_content?(item.price)
    refute page.has_content?(item2.title)
  end
end
