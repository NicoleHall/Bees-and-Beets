class VendorDashboardsController < ApplicationController

  def show
    @vendor = current_user.vendor
  end
end
