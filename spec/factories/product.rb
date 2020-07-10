# spec/factories/user.rb
require "faker"

FactoryBot.define do
  factory :product do
    name {Faker::Beer.name}
    category_id {1}
    unit_price {Faker::Number.between(from: 1, to: 10)}
    quantity {Faker::Number.between(from: 1, to: 10)}
  end
end
