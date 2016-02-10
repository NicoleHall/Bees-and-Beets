class ItemsController < ApplicationController

  def index
      @category = Category.find_by(url: params[:category_url])
      @items = @category.items
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
end
