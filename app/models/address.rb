class Address < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  validates :label, presence: true, uniqueness: { scope: :user }
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
end
