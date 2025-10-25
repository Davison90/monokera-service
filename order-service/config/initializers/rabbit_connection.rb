require 'bunny'

module RabbitConnection
  class << self
    attr_reader :connection, :channel

    def start
      Rails.logger.info("[OrderService] Starting RabbitMQ connection initializer...")
      return if @connection&.open?

      Rails.logger.info("[OrderService] Establishing RabbitMQ connection...")
      @connection = Bunny.new(
        hostname: ENV.fetch('RABBITMQ_HOST', 'rabbitmq'),
        username: ENV.fetch('RABBITMQ_USERNAME', 'guest'),
        password: ENV.fetch('RABBITMQ_PASSWORD', 'guest'),
        automatically_recover: true,
        network_recovery_interval: 5
      )
      @connection.start

      @channel = @connection.create_channel

      Rails.logger.error("[OrderService] RabbitMQ connection succesfully")
    rescue Bunny::TCPConnectionFailedForAllHosts => e
      Rails.logger.error("[OrderService] RabbitMQ connection failed: #{e.message}")
      @connection = nil
      @channel = nil
    end
  end

  def self.open?
    @connection&.open?
  end

  def self.close
    if @connection&.open?
      @connection.close
      Rails.logger.info("OrderService RabbitMQ connection closed")
    end
  end
end

RabbitConnection.start