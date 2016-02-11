class VendorsController < ApplicationController
  before_action :check_vendor_status, only: [:edit, :update]

  def index
      @vendors = Vendor.where(status: 1)
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params, owner_id: current_user.id)
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

  def edit
    check_vendor_status
    @vendor = Vendor.find(params[:id])
  end

  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update(vendor_params)
      if current_platform_admin?
        redirect_to platform_dashboard_path
      else
        redirect_to vendor_dashboard_path
      end
    else
      flash.now[:error] = "All fields must be filled in."
      render :edit
    end
  end

  private

  def check_vendor_status
    render file: "public/404" unless current_platform_admin? || (params[:id].to_i == current_user.vendor_id)
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :image_path)
  end
end
