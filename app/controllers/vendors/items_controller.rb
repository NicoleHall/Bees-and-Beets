class Vendors::ItemsController < Vendors::VendorsController
  # before_action :item_belongs_to_current_vendor, only: [:edit, :update]
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
      flash.now[:error] = "All fields must be filled in."
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

  # def require_vendor
  #   render file: "/public/404" unless current_user.id = current_vendor.id
  # end

  # def current_vendor
  #   @current_vendor ||= Vendor.find_by(url: params[:vendor])
  # end

  # def item_belongs_to_current_vendor
  #   render file: "/public/404" unless item_vendor_id_is_current_vendor
  # end
  #
  # def item_vendor_id_is_current_vendor
  #   Item.find(params[:id]).current_vendor.id == current_user.id
  # end
end
