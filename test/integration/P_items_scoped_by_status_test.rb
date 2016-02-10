require 'test_helper'

class ItemsScopedByStatusTest < ActionDispatch::IntegrationTest
  test "users and guests cant see inactive items" do
    # As a guest or registered user
    # When I visit the categories/items
    # I cant see inactive items
    # And when I visit the vendors index
    # And I cant see vendors that havent been approved
    vendor = create(:vendor_with_items)
    active_item = vendor.items.first
    inactive_item = vendor.items.last

    visit vendors_path
    refute page.has_content?("#{vendor.name}")

    visit vendor_items_path(vendor: vendor.url)
    message_404 = "The page you were looking for doesn't exist (404)"
    assert page.has_content? message_404

    vendor.update_attributes(status: 1)
    vendor.reload

    inactive_item.update_attributes(status: 0)
    inactive_item.reload

    visit vendors_path
    assert page.has_content?("#{vendor.name}")

    visit vendor_items_path(vendor: vendor.url)
    refute page.has_content?("#{inactive_item.title}")
    assert page.has_content?("#{active_item.title}")
  end
end
