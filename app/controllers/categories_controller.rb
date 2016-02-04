class CategoriesController < ApplicationController
  # def show
  #   @category = Category.find_by_slug(params[:slug])
  # end

  def index
    @categories = Category.all.includes(:items)
  end

  def show
    @category = Category.find(params[:id])
  end

end
