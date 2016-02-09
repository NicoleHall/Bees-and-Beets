require 'test_helper'

class VendorTest < ActiveSupport::TestCase
    should validate_uniqueness_of(:name)
    should validate_presence_of(:name)
    should validate_presence_of(:description)

  test "cannot create vendor without name" do
    vendor = Vendor.new(description: "stuff")

    refute vendor.valid?
  end

  test "cannot create vendor without description" do
    vendor = Vendor.new(name: "stuff")

    refute vendor.valid?
  end

  test "vendor status count" do
    create(:vendor, status: 1)
    create(:vendor, status: 0)
    create(:vendor, status: 0)
    create(:vendor, status: 2)

    expected = [["Open", 1], ["Pending", 2], ["Closed", 1]]
    assert_equal expected, Vendor.vendor_status_count
  end
end
