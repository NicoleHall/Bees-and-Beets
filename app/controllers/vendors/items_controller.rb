class Vendors::ItemsController < Vendors::VendorsController
  # before_action :current_vendor
  # helper_method :current_vendor

  def index
    @items = current_vendor.items
  end

  def show
    @item = current_vendor.items.find(params[:id])
  end

  def new
    @item = current_vendor.items.new
  end

  def create
    sanitize_price(params[:item][:price])
    @item = current_vendor.items.new(item_params)
    if @item.save
      redirect_to vendor_items_path(vendor: current_vendor.url)
    else
      flash.now[:error] = "Incomplete form"
      render :new
    end
  end

  def edit
    @item = current_vendor.items.find(params[:id])
  end

  def update
    @item = current_vendor.items.find(params[:id])
    if @item.update_attributes(item_params)
      redirect_to vendor_items_path(vendor: current_vendor.url)
    else
      flash.now[:error] = "Incorrect user information"
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:title,
                                 :image_path,
                                 :price,
                                 :description,
                                 :category_id,
                                 :status,
                                 :file_upload)
  end
  #
  # def current_vendor
  #   @current_vendor ||= Vendor.find_by(url: params[:vendor])
  # end
end
