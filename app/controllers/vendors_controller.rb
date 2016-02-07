class VendorsController < ApplicationController
  def index
    @vendors = Vendor.all
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      User.find(current_user.id).update_attributes(vendor_id: @vendor.id)
      flash[:success] = "Your kiosk is pending approval."
      redirect_to vendor_dashboard_path
    else
      redirect_to new_vendor_path
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :status, :image_path)
  end
end
