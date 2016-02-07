require "test_helper"

class ItemTest < ActiveSupport::TestCase
  should validate_presence_of(:title)
  should validate_presence_of(:vendor_id)
  should validate_presence_of(:category_id)
  should validate_presence_of(:price)
  should validate_presence_of(:description)

  test "item can belong to an vendor" do
    vendor = create(:vendor)
    category = create(:category)
    vendor.items.create(title: "Title",
                        description: "Description",
                        price: 10,
                        category_id: category.id,
                        image_path: "http://example.jpg")

    assert_equal 1, vendor.items.count
  end

  test "item cannot have the same title as another item" do
    vendor = create(:vendor)
    category = create(:category)
    vendor.items.create(title: "Title",
                        description: "Description",
                        price: 10,
                        category_id: category.id,
                        image_path: "http://example.jpg")

    assert_equal 1, vendor.items.count

    vendor.items.create(title: "Title",
                        description: "Description Two",
                        price: 20,
                        category_id: category.id,
                        image_path: "http://example2.jpg")

    assert_equal 1, vendor.items.count
  end

  test "item price cannot be negative" do
    vendor = create(:vendor)
    category = create(:category)
    vendor.items.create(title: "Title",
                        description: "Description",
                        price: -100,
                        category_id: category.id,
                        image_path: "http://example.jpg")

    assert_equal 0, vendor.items.count
  end

  test "item price cannot be zero" do
    vendor = create(:vendor)
    category = create(:category)
    vendor.items.create(title: "Title",
                        description: "Description",
                        price: 0,
                        category_id: category.id,
                        image_path: "http://example.jpg")

    assert_equal 0, vendor.items.count
  end

  test "item price cannot be a set of characters" do
    vendor = create(:vendor)
    category = create(:category)
    vendor.items.create(title: "Title",
                        description: "Description",
                        price: "abc",
                        category_id: category.id,
                        image_path: "http://example.jpg")

    assert_equal 0, vendor.items.count
  end

  test "item image is optional and a default is assigned if it is blank" do
    vendor = create(:vendor)
    category = create(:category)
    vendor.items.create(title: "Title",
                        description: "Description",
                        price: 10,
                        category_id: category.id)

    photo_not_available = "https://www.weefmgrenada.com/images/na4.jpg"

    assert_equal 1, vendor.items.count
    assert_equal photo_not_available, vendor.items.last.image_path
  end

  test "can filter by active items only" do
    item1 = create(:item)
    item2 = create(:item)
    item2.inactive!

    assert item1.active?
    refute item2.active?

    assert_equal 1, Item.active.count
  end
end
