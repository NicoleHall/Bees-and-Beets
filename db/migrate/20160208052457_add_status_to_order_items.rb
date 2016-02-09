class AddStatusToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :status, :integer, default: 0
  end
end
