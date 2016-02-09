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
    User.find_by_username(params[:username])
  end

end
