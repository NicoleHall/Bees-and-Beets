class Vendor < ActiveRecord::Base
  has_many :items
  has_many :users
  has_many :order_items
  has_many :orders, through: :order_items

  before_create :generate_url
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  enum status: %w(pending open closed)

  def generate_url
    self.url = self.name.parameterize
  end

  def self.status_pending?
    statuses = self.pluck(:status)
    statuses.include?(0)
  end

  def pending?
    self.status == 0
  end

  def open?
    self.status == 1
  end

  def closed?
    self.status == 2
  end
end
