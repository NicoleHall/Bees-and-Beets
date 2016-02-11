class CategoriesController < ApplicationController
  def index
    @categories = Category.desc_order_include_items
  end
end
