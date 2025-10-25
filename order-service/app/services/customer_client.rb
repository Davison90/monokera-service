class CustomerClient
  include HTTParty

  base_uri ENV.fetch('CUSTOMER_SERVICE_URL')

  def self.fetch_customer(customer_id)
    get("/api/v1/customers/#{customer_id}")
  end
end