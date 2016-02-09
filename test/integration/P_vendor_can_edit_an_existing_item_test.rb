require "test_helper"

class VendorCanEditAnExistingItemTest < ActionDispatch::IntegrationTest
  test "vendor edits an existing item from artist item index" do
    vendor = create(:vendor_with_user, status: 1)
    user = vendor.users.first
    item = vendor.items.first
    category = create(:category)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    binding.pry
    visit vendor_items_path(vendor: vendor.url)
    within(".vendor_item_#{item.id}") do
      click_on "Edit Item"
    end

    fill_in "Title", with: "New Title"
    click_on "Update Item"

    assert_equal vendor_items_path(vendor: vendor.url), current_path
    assert page.has_content? "New Title"
  end

  test "artist edits an existing item from item show page" do
    skip
    artist = create(:artist)
    item = create(:item)
    artist.items << item

    ApplicationController.any_instance.stubs(:current_user).returns(artist)

    visit item_path(item)
    click_on "Edit"

    fill_in "Title", with: "New Title"
    click_on "Update Item"

    assert_equal item_path(item), current_path
    assert page.has_content? "New Title"
  end

  test "artist cannot edit another artist's item from item show page" do
    skip
    artist1 = create(:artist)
    item1 = create(:item)
    artist1.items << item1

    artist2 = create(:artist)
    item2 = create(:item)
    artist2.items << item2

    ApplicationController.any_instance.stubs(:current_user).returns(artist1)

    visit item_path(item2)
    refute page.has_content? "Edit"
  end

  test "artist cannot edit another artist's item from item index page" do
    skip
    artist1 = create(:artist)

    artist2 = create(:artist)
    item2 = create(:item)
    artist2.items << item2

    ApplicationController.any_instance.stubs(:current_user).returns(artist1)

    visit items_path
    refute page.has_content? "Edit"
  end

  test "artist cannot go directly to another artist's edit item page" do
    skip
    artist1 = create(:artist)

    artist2 = create(:artist)
    item2 = create(:item)
    artist2.items << item2

    ApplicationController.any_instance.stubs(:current_user).returns(artist1)

    visit edit_user_item_path(artist2, item2)
    message_404 = "The page you were looking for doesn't exist (404)"
    assert page.has_content?(message_404)
  end

  test "artist cannot leave required fields blank when editing an item" do
    skip
    artist = create(:artist)
    item = create(:item)
    artist.items << item

    ApplicationController.any_instance.stubs(:current_user).returns(artist)

    visit artist_path(artist)
    click_on "Edit"

    fill_in "Title", with: ""
    click_on "Update Item"

    assert page.has_content? "All fields must be filled in."
  end
end
