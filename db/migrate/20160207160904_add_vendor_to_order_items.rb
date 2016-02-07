class AddVendorToOrderItems < ActiveRecord::Migration
  def change
    add_reference :order_items, :vendor, index: true, foreign_key: true
  end
end
