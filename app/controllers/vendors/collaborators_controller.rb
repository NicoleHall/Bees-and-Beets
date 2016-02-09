class Vendors::CollaboratorsController < Vendors::VendorsController

  def index

  end

  def new
  end

  def create
  end

  def edit
  end

  def update
    user=User.find_by_username(params[:username])
    user.update_attribute(:role, 3)
  end

end
