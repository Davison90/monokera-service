require 'bunny'

class OrderCreatedPublisher
  def self.publish(order)
    RabbitConnection.start

    channel = RabbitConnection.channel
    return unless channel

    exchange = channel.topic('orders_exchange', durable: true)
    payload = order.to_json
    exchange.publish(payload, routing_key: 'order.created', persistent: true)

    Rails.logger.info("Order published to RabbitMQ: #{order.id}")
  ensure
    RabbitConnection.close if RabbitConnection.open?
  end
end