require "rails_helper"

RSpec.describe Api::V1::OrdersController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "api/v1/orders").to route_to("api/v1/orders#create")
    end

    it "routes to #client_orders" do
      expect(get: "api/v1/orders/1/customer_orders").to route_to("api/v1/orders#customer_orders", customer_id: "1")
    end
  end
end
