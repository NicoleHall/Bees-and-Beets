class CategoriesController < ApplicationController
  def index
    @categories = Category.order(updated_at: :desc).includes(:items)
  end
end
