class CategoriesController < ApplicationController
  def index
    @categories = Category.all.includes(:items)
  end
end
