class Vendor < ActiveRecord::Base
  has_many :items
  before_validation :generate_url
  validates :name, presence: true, uniqueness: true

  def generate_url
    self.url = self.name.parameterize
  end
end
