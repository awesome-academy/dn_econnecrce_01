require "spec_helper"
require "rails_helper"

describe User, type: :model do

  # test association with shoulda matchers
  describe "#association" do
    it {should have_many(:purchases)}
    it {should have_many(:ratings)}
    it {should have_secure_password}
    it {should respond_to(:image)}
    it {should have_secure_password}
  end

  # test validates with factory bot
  describe "#validates" do
    let!(:user){FactoryBot.build :user}

    it {should_not be_valid}
    it {should validate_presence_of :name}
    it {should validate_length_of :name}
    it {should validate_presence_of :email}
    it {should validate_length_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}
    it {should validate_length_of :password}
    it {should validate_presence_of :address}
    it {should validate_presence_of :phone_number}
    it {should validate_uniqueness_of :phone_number}
    it {should validate_length_of :phone_number}

    context "with email format" do
      it {should allow_value("omgod234@gmail.com").for(:email)}
    end
    context "when email is invalid" do
      it {should_not allow_value("asdasdsa").for(:email)}
    end
    context "with phone_number format " do
      it {should allow_value("0941789420").for(:phone_number)}
    end
    context "when phone_number is invalid " do
      it {should_not allow_value("asdas").for(:phone_number)}
    end
  end
end
