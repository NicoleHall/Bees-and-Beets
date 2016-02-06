class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user, index: true, foreign_key: true
      t.string :label
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps null: false
    end
  end
end
