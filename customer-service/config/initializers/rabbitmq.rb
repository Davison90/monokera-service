unless Rails.env.test?
  Rails.application.config.after_initialize do
    OrderCreatedConsumer.start
  end
end