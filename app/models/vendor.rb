class Vendor < ActiveRecord::Base
  has_many :items
  has_many :users
  has_many :order_items
  has_many :orders, through: :order_items

  before_save :generate_url

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

  def self.vendor_status_count
    status_freq = group(:status).count
    (0..2).to_a.each do |status|
      status_freq[status] ||= 0
    end

    status_freq.map do |status, count|
      [Vendor.statuses.key(status).capitalize, count]
    end
  end
end
