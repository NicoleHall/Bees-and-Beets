class Vendor::ItemsController < Vendor::VendorsController
  def index
    @items = current_vendor.items
  end

  def show
    @item = current_vendor.items.find(params[:id])
  end
end
