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
end
