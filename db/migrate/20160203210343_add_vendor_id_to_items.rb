class AddVendorIdToItems < ActiveRecord::Migration
  def change
    add_reference :items, :vendor, index: true, foreign_key: true
    remove_column :items, :user_id
  end
end
