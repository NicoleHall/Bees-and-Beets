class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item
  belongs_to :vendor

  enum status: %w(ordered completed cancelled)

  def self.sum_price(vendor_id)
    where(vendor_id: vendor_id).inject(0) do |sum, order_item|
      sum + (order_item.quantity * order_item.item.price).to_i
    end
  end

  def price
    item.price
  end
end
