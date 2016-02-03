class DropColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :street_address
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zipcode
  end
end
