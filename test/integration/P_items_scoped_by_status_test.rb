require 'test_helper'

class ItemsScopedByStatusTest < ActionDispatch::IntegrationTest
  test "guests cant see inactive items or pending vendors" do
    vendor = create(:vendor_with_items)
    active_item = vendor.items.first
    inactive_item = vendor.items.last
    inactive_item.update_attributes(status: 0)

    visit vendors_path
    refute page.has_content?("#{vendor.name}")

    visit vendor_items_path(vendor: vendor.url)
    message_404 = "The page you were looking for doesn't exist (404)"
    assert page.has_content? message_404

    vendor.update_attributes(status: 1)

    visit vendors_path
    assert page.has_content?("#{vendor.name}")

    visit vendor_items_path(vendor: vendor.url)
    refute page.has_content?("#{inactive_item.title}")
    assert page.has_content?("#{active_item.title}")
  end

  test "registered users cant see inactive items or pending vendors" do
    user = create(:user, role: 0)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

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

  test "vendor admins can only see their own pending store and items" do
    vendor_1, vendor_2 = create_list(:vendor_with_user, 2)

    vendor_admin_1 = vendor_1.users.first
    vendor_1_active_item = vendor_1.items.first
    vendor_1_inactive_item = vendor_1.items.last
    vendor_1_inactive_item.update_attributes(status: 0)

    vendor_admin_2 = vendor_2.users.first
    vendor_2_active_item = vendor_2.items.first
    vendor_2_inactive_item = vendor_2.items.last
    vendor_2_inactive_item.update_attributes(status: 0)

    ApplicationController.any_instance.stubs(:current_user).returns(vendor_admin_1)

    visit vendors_path
    refute page.has_content?("#{vendor_1.name}")
    refute page.has_content?("#{vendor_2.name}")
    visit vendor_items_path(vendor: vendor_1.url)
    assert page.has_content?("Pending Approval")
    within("#vendor_item_#{vendor_1_active_item.id}") do
      assert page.has_content?("#{vendor_1_active_item.title}")
      assert page.has_content?("Edit Item")
    end

    within("#vendor_item_#{vendor_1_inactive_item.id}") do
      assert page.has_content?("#{vendor_1_inactive_item.title}")
      refute page.has_content?("Add To Cart")
      assert page.has_content?("Edit")
      assert page.has_content?("This item is inactive.")
    end

    # OPEN VENDOR
    vendor_1.update_attributes(status: 1)

    visit vendors_path
    within "##{vendor_1.name}" do
      assert page.has_content?("#{vendor_1.name}")
    end

    refute page.has_content?("#{vendor_2.name}")

    visit vendor_items_path(vendor: vendor_2.url)
    message_404 = "The page you were looking for doesn't exist (404)"
    assert page.has_content? message_404
  end
end
