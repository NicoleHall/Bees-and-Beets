class ItemsController < ApplicationController
  def index
    @category = Category.find_by(url: params[:category_url])
    @items = @category.items.joins(:vendor).where("vendors.status = ?", 1)
  end
end
