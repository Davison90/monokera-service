require 'rails_helper'

RSpec.describe Order, type: :model do
  before do
    ENV['CUSTOMER_SERVICE_URL'] = 'http://customer-service:3000'
    allow(CustomerClient).to receive(:fetch_customer).and_return(double(success?: true, parsed_response: { "id" => 1, "name" => "John Doe" }))
  end

  it { should validate_presence_of(:customer_id) }
  it { should validate_presence_of(:product_name) }
  it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  it { should validate_numericality_of(:price).is_greater_than(0.0) }

  describe 'custom validations' do
    context 'check_customer_info' do
      let(:customer_id) { 1 }
      let(:order) { Order.new(customer_id: customer_id, product_name: "Test Product", quantity: 2, price: 10.0) }

      it 'sets customer_info if fetch is successful' do
        customer_info = { "id" => customer_id, "name" => "John Doe" }
        allow(CustomerClient).to receive(:fetch_customer).with(customer_id).and_return(double(success?: true, parsed_response: customer_info))

        order.valid?

        expect(order.customer_info).to eq(customer_info)
      end
    end
  end
end
