class Vendor::VendorsController < ApplicationController
  helper_method :current_vendor
  before_action :vendor_not_found

  def current_vendor
    @current_vendor ||= Vendor.find_by(url: params[:vendor])
  end

  def vendor_not_found
    redirect_to vendors_path if current_vendor.nil?
  end
end
