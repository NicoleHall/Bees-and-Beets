class DropAddressesTable < ActiveRecord::Migration
  def change
    remove_reference :orders, :address, index: true, foreign_key: true
    drop_table :addresses
  end
end
