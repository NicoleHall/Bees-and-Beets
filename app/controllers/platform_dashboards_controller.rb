class PlatformDashboardsController < ApplicationController

  def show
    @vendors = Vendor.all
  end

end
