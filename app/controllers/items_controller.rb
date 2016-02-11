class ItemsController < ApplicationController
  def index
    @category = Category.find_by(url: params[:category_url])
    @items = @category.items.open_vendors_only
  end
end
