FactoryBot.define do
  factory :order do
    customer_id { 1 }
    product_name { Faker::Commerce.product_name }
    quantity { 1 }
    price { 1.5 }
    status { true }
  end
end
