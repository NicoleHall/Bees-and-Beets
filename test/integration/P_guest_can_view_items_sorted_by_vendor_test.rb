require "test_helper"

class GuestCanViewItemsSortedByArtistTest < ActionDispatch::IntegrationTest
  test "items are shown under their assigned vendor" do
    # vendor_1 = create(:vendor_with_items)
    # vendor_2 = create(:vendor_with_items)
    vendor_1, vendor_2 = create_list(:vendor_with_items, 2)
    user = create(:user)

    visit vendors_path

    assert page.has_content?(vendor_1.name)
    within "\##{vendor_1.name}" do
      assert page.has_content?(vendor_1.items.first.title)
      assert page.has_content?(vendor_1.items.last.title)
      refute page.has_content?(vendor_2.items.first.title)
      refute page.has_content?(vendor_2.items.last.title)
    end

    assert page.has_content?(vendor_2.name)
    within "\##{vendor_2.name}" do
      assert page.has_content?(vendor_2.items.first.title)
      assert page.has_content?(vendor_2.items.last.title)
      refute page.has_content?(vendor_1.items.first.title)
      refute page.has_content?(vendor_1.items.last.title)
    end

    refute page.has_content?(user.full_name)
  end
end
