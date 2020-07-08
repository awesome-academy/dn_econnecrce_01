# spec/factories/user.rb
require "faker"

FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    address {Faker::Address.full_address}
    phone_number {"0941789420"}
    password {"foobar"}
    password_confirmation {"foobar"}
  end
end
