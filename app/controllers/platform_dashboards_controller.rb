class PlatformDashboardsController < ApplicationController

  def show
    @vendors = Vendor.order(updated_at: :desc)
  end

end
