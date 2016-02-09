class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_cart
  helper_method :current_user


  helper_method :current_platform_admin?
  helper_method :current_vendor?
  # helper_method :artist_owns_item?

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

 
  #
  # def artist_owns_item?(item)
  #   item.user.id == current_user.id
  # end

  def sanitize_price(price)
    price.to_s.gsub!(/[,$]/, "").to_i
  end
end
