class Order < ApplicationRecord
  validates :customer_id, presence: true
  validates :product_name, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than: 0.0 }

  validate :check_customer_info, on: :create

  after_create :publish_order_created_event

  private

  def check_customer_info
    Rails.logger.info("Fetching customer info for customer_id: #{self.customer_id}")
    response = CustomerClient.fetch_customer(self.customer_id)

    return errors.add(:customer_info, response["mssg"]) unless response&.success?

    Rails.logger.info("Customer info fetched successfully for customer_id: #{self.customer_id}")
    self.customer_info = response.parsed_response
  end

  def publish_order_created_event
    unless OrderCreatedPublisher.publish(self)
      Rails.logger.error("Failed to publish order created event for order_id: #{self.id}")
      errors.add(:base, "Failed to publish order created event")
      raise ActiveRecord::Rollback, "Failed to publish to RabbitMQ"
    end
  end
end
