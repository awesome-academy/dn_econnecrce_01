class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  scope :sorted, ->{order :name}

  accepts_nested_attributes_for :products

  scope :recent_categories, ->{order created_at: :desc}

  validates :name, length: {maximum: Settings.name_maximum, message: :bad_name},
   presence: true
end
