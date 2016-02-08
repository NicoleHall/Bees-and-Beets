class Vendors::OrdersController < Vendors::VendorsController
  def index
    @order_items = current_vendor.order_items
  end

  def update
    OrderItem.find(params[:id]).update_attribute(:status, params[:status].to_i)
    redirect_to vendor_orders_path
  end
end
