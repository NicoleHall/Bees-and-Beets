class Vendor::VendorsController < ApplicationController
  attr_reader :current_vendor
  before_action :vendor_not_found
  helper_method :current_vendor

  def current_vendor
    @current_vendor ||= Vendor.find_by(url: params[:vendor])
  end

  def vendor_not_found
    redirect_to vendors_path if current_vendor.nil?
  end
end
