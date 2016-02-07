require 'test_helper'

class AdminApprovesPendingStoreTest < ActionDispatch::IntegrationTest
  test "an admin must approve pending stores for activation" do
    

    visit '/platform_dashboard'

    assert page.has_content?("Stores Pending Approval")
    assert page.has_content?
  end
end
