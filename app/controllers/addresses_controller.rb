class AddressesController < ApplicationController
  def new
    @address = Address.new
  end

  def create
    @address = current_user.addresses.new(address_params)

    if @address.save
      redirect_to addresses_path
    else
      flash.now[:error] = "Incomplete form"
      render :new
    end
  end

  def index
    @addresses = current_user.addresses
  end

  private

  def address_params
    params.require(:address).permit(:label, :street, :city, :state, :zipcode)
  end
end
