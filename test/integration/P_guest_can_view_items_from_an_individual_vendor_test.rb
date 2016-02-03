require "test_helper"

class GuestCanViewItemsFromAnIndividualVendorTest < ActionDispatch::IntegrationTest
  test "guest sees only items from the specific vendor" do
    vendor1 = create(:vendor_with_items)
    vendor2 = create(:vendor_with_items)

    visit vendor_items_path(vendor: vendor1.url)

    assert page.has_content?("#{vendor1.items.first.title}")
    assert page.has_content?("#{vendor1.items.last.title}")
    refute page.has_content?("#{vendor2.items.first.title}")
    refute page.has_content?("#{vendor2.items.last.title}")
  end
end
