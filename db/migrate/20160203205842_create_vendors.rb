class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.integer :status, default: 0
      t.string :name
      t.string :description
      t.string :image_path

      t.timestamps null: false
    end
  end
end
