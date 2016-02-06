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

  def edit
    @address = current_user.addresses.find(params[:id])
  end

  def update
    @address = current_user.addresses.find(params[:id])

    if @address.update(address_params)
      redirect_to addresses_path
    else
      flash.now[:error] = "Incomplete form"
      render :edit
    end
  end

  def destroy
    @address = current_user.addresses.find(params[:id])
    
    if @address.orders.empty?
      @address.destroy
    else
      flash.now[:error] = "Cannot delete addresses associated with orders."
    end

    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:label, :street, :city, :state, :zipcode)
  end
end
