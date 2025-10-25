require "rails_helper"

RSpec.describe Api::V1::CustomersController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "api/v1/customers/1").to route_to("api/v1/customers#show", id: "1")
    end
  end
end
