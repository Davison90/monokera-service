module OrderCreatedConsumer
  def self.start
    begin
      Rails.logger.info "[CustomerService] Starting RabbitMQ consumer for order.created events"
      connection = Bunny.new(hostname: ENV.fetch('RABBITMQ_HOST', 'rabbitmq'),
                             username: ENV.fetch('RABBITMQ_USERNAME', 'guest'),
                             password: ENV.fetch('RABBITMQ_PASSWORD', 'guest'),
                             automatically_recover: true,
                             network_recovery_interval: 5)
      connection.start

      channel = connection.create_channel
      exchange = channel.topic('orders_exchange', durable: true)
      q = channel.queue('customer-service.order-created', durable: true).bind(exchange, routing_key: 'order.created')
      q.subscribe(block: false, manual_ack: true) do |delivery_info, properties, payload|
        data = JSON.parse(payload)
        customer_id = data['customer_id']
        customer = Customer.find_by(id: customer_id)
        if customer
          customer.update(orders_count: (customer&.orders_count || 0) + 1)
          Rails.logger.info "[CustomerService] Customer with ID #{customer.id} orders_count incremented to #{customer.orders_count}"
        else
          Rails.logger.info "[CustomerService] Customer with ID #{customer_id} not found."
        end

        channel.ack(delivery_info.delivery_tag)
      end
    rescue => e
      Rails.logger.error "[CustomerService] RabbitMQ consumer error: #{e.message}"
      sleep 5
      retry
    end
  end
end