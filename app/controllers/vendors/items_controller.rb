class Vendors::ItemsController < Vendors::VendorsController
  # before_action :current_vendor
  # helper_method :current_vendor

  def index
    @items = current_vendor.items
  end

  def show
    @item = current_vendor.items.find(params[:id])
  end

  # private
  #
  # def current_vendor
  #   @current_vendor ||= Vendor.find_by(url: params[:vendor])
  # end
end
