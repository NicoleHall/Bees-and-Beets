require 'test_helper'
class GuestSeesBrowseButtonOnLandingPageTest < ActionDispatch::IntegrationTest
  test "guest can visit landing page and see browse buttons" do
    visit '/'

    assert page.has_link?("Shop Vendors")
    assert page.has_link?("Shop Categories")
    assert page.has_link?("Log In/Sign Up")
  end
end
