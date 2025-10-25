class Customer < ApplicationRecord
  validates :customer_name, presence: true
  validates :address, presence: true

  before_create :set_default_orders_count, if: :new_record?

  private

  def set_default_orders_count
    self.orders_count ||= 0
  end
end
