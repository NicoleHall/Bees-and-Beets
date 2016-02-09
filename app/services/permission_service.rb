class PermissionService
  extend Forwardable
  attr_reader :user, :controller, :action
  def_delegators :user, :platform_admin?,
                        :vendor_admin?,
                        :registered_user?

  def initialize(user)
    @user = user || User.new
  end

  def allow?(controller, action)
    @controller = controller
    @action = action

    case
    when platform_admin?
      platform_admin_permissions
    when vendor?
      vendor_permissions
    when customer?
      customer_permissions
    else
      guest_user_permissions
    end

    def platform_admin_permissions
      return true if controller == "platform_dashboards" && action.in?(%w(show))
      return true if controller == "vendors" && action.in?(%w(open close pending))
      vendor_permissions
    end

    def vendor_permissions
      return true if controller == "vendors" && action.in?(%w(new create edit update))
      return true if controller == "vendor_dashboards" && action.in?(%w(show))
      return true if controller == "vendor/items" && action.in?(%w(new create edit update))
      return true if controller == "vendors/orders" && action.in?(%w(index show update))
      customer_permissions
    end

    def customer_permissions
      return true if controller == "users" && action.in?(%w(show edit update))
      return true if controller == "orders" && action.in?(%w(index create show))
      guest_user_permissions
    end

    def guest_user_permissions
      return true if controller == "home"
      return true if controller == "sessions"
      return true if controller == "users" && action.in?(%w(new create))
      return true if controller == "vendors" && action.in?(%w(index))
      return true if controller == "vendors/items" && action.in?(%w(index show))
      return true if controller == "categories" && action.in?(%w(index))
      return true if controller == "items" && action.in?(%w(index))
      return true if controller == "cart_items" && action.in?(%w(index update destroy create))
    end

  end
end
