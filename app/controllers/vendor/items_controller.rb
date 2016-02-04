class Vendor::ItemsController < Vendor::VendorsController
  def index
    @items = current_vendor.items
  end
end
