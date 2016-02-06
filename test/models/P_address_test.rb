require "test_helper"

class AddressTest < ActiveSupport::TestCase
  should validate_presence_of(:label)
  should validate_presence_of(:street)
  should validate_presence_of(:city)
  should validate_presence_of(:state)
  should validate_presence_of(:zipcode)

  test "address can belong to a user" do
    user = create(:user)
    user.addresses.create(label: "Office",
                          street: "1510 Blake St.",
                          city: "Denver",
                          state: "CO",
                          zipcode: "80220")

    assert_equal 1, user.addresses.count
  end

  test "address cannot have the same label as another address" do
    user = create(:user)
    user.addresses.create(label: "Office",
                          street: "1510 Blake St.",
                          city: "Denver",
                          state: "CO",
                          zipcode: "80220")

    assert_equal 1, user.addresses.count

    user.addresses.create(label: "Office",
                          street: "1510 Blake St. LL",
                          city: "Denver",
                          state: "CO",
                          zipcode: "80220")

    assert_equal 1, user.addresses.count
  end
end
