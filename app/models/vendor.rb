class Vendor < ActiveRecord::Base
  has_many :items

  before_create :generate_url

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def generate_url
    self.url = self.name.parameterize
  end
end
