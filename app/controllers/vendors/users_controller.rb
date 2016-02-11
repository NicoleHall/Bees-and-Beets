class Vendors::UsersController < Vendors::VendorsController
  before_action :check_vendor_status

  def index
    @users = current_vendor.users
  end

  def new
  end

  def create
    user = User.find_by(username: collaborator_params[:username])
    if user
      user.update_attributes(role: 1, vendor_id: current_vendor.id)
      redirect_to vendor_users_path(vendor: current_vendor.url)
    else
      flash[:error] = "User not found."
      render :new
    end
  end

  def update
    user = User.find(params[:id])
    user.update_attributes(vendor_id: nil)
    redirect_to vendor_users_path(vendor: current_vendor.url)
  end

  private

    def collaborator_params
      params.require(:new_collaborator).permit(:username)
    end

    def check_vendor_status
      render file: "public/404" unless current_user.platform_admin? ||
                                       (current_vendor.id == current_user.vendor_id &&
                                       current_user.id == current_vendor.owner_id)
    end
end
