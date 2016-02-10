class VendorsController < ApplicationController

  def index
      @vendors = Vendor.where(status: 1)
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

  def open
    Vendor.update(params[:vendor_id], status: 1)
    redirect_to platform_dashboard_path
  end

  def close
    Vendor.update(params[:vendor_id], status: 2)
    redirect_to platform_dashboard_path
  end

  def pending
    Vendor.update(params[:vendor_id], status: 0)
    redirect_to platform_dashboard_path
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  def update
    @vendor = Vendor.find(params[:id])

    if @vendor.update(vendor_params)
      redirect_to vendor_dashboard_path
    else
      flash.now[:error] = "All fields must be filled in."
      render :edit
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :image_path)
  end
end
