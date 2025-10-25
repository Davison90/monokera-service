require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should validate_presence_of(:customer_name) }
  it { should validate_presence_of(:address) }

  it "Has a valid factory" do
    expect(FactoryBot.build(:customer)).to be_valid
  end

  it "Sets default orders_count to 0 if not provided" do
    customer = FactoryBot.create(:customer, orders_count: nil)
    expect(customer.orders_count).to eq(0)
  end
end
