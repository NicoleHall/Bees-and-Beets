class VendorDashboardsController < ApplicationController

  def show
    # binding.pry
    @vendor = current_user.vendor
  end
end
