class AddUrlToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :url, :string
    remove_column :categories, :slug
  end
end
