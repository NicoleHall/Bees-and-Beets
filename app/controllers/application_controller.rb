class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_cart
  helper_method :current_user
  before_action :authorize!
  helper_method :current_platform_admin?
  helper_method :current_vendor?
  helper_method :vendor_owns_item?

  def current_permission
    @current_permission ||= PermissionService.new(current_user)
  end

  def authorized?
    current_permission.allow?(params[:controller], params[:action])
  end

  def authorize!
    unless authorized?
      redirect_to root_url, danger: "You are neither a Bee or Beet!"
    end
  end

  def set_cart
    @cart = Cart.new(session[:cart])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_platform_admin?
      current_user && current_user.platform_admin?
    end

  def current_vendor?
    current_user && current_user.vendor?
  end

  def vendor_owns_item?(item)
    item.vendor.id == current_user.vendor.id
  end

  def sanitize_price(price)
    price.to_s.gsub!(/[,$]/, "").to_i
  end
end
