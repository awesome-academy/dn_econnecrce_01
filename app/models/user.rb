class User < ApplicationRecord
  # association one user has many Ratings
  has_many :ratings, dependent: :destroy

  # association one user has many purchases
  has_many :purchases, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
   enum role: {user: 1, admin: 2}

  # active record 1 user 1 image
  has_one_attached :image

  # constant regex email vs phone_number
  VALID_PHONE_NUMBER_REGEX = /\d[0-9]\)*\z/.freeze

  # validations and macro
  validates :email, length: {maximum: Settings.email_maximum,
                             message: :bad_email},
   presence: true,
   uniqueness: true
  validates :username, length: {maximum: Settings.name_maximum,
                            message: :bad_name},
   presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :phone_number, length: {maximum: Settings.phone_number_maximum,
                                    minimum: Settings.phone_number_minimum,
                                    message: :bad_phone_number},
   format: {with: VALID_PHONE_NUMBER_REGEX,
            message: :bad_phone_number},
   presence: true,
   uniqueness: true, on: :update
end
