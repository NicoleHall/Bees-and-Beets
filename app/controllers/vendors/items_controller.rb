class Vendors::ItemsController < Vendors::VendorsController
  before_action :item_belongs_to_current_vendor, only: [:edit, :update]
  before_action :check_vendor_status

  def index
    check_vendor_status
    @items = current_vendor.items.where(status: 1)
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

  def require_vendor
    render file: "/public/404" unless current_user.vendor.id == current_vendor.id
  end

  def item_belongs_to_current_vendor
    render file: "/public/404" unless item_vendor_id_is_current_vendor
  end

  def item_vendor_id_is_current_vendor
    Item.find(params[:id]).vendor_id == current_user.vendor.id
  end

  def check_vendor_status
    render file: "public/404" unless current_vendor.status == "open" || current_user.vendor.id == current_vendor.id
  end
end
