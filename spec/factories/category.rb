# spec/factories/user.rb
require "faker"

FactoryBot.define do
  factory :category do
    name {Faker::Beer.brand}
  end
end
