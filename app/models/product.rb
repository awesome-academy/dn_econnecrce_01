class Product < ApplicationRecord
  # 1 product belong_to 1 category
  belongs_to :category

  # 1 product has many rating
  has_many :ratings, dependent: :destroy

  # 1 product has many details purchase
  has_many :detailpurchases, dependent: :destroy

  # active record 1 product 1 image
  has_one_attached :image

  scope :recent_product, ->{order created_at: :desc}
  scope :sorted, ->{order :name}
  scope :top_product, (lambda do
    joins(:detailpurchases)
      .group(:product_id)
      .order("COUNT(product_id) DESC")
      .limit(2)
  end)

  validates :name, length: {maximum: Settings.name_maximum, message: :bad_name},
   presence: true
  validates :unit_price, numericality: {greater_than: Settings.price_greater,
                                        less_than: Settings.price_less}
  validates :quantity, numericality: {greater_than: Settings.price_greater,
                                      less_than: Settings.price_less}
  validates :image, content_type: {in: Settings.file_valid, message: :bad_image}

  def display_image
    image
      .variant resize_to_limit: [Settings.image_display, Settings.image_display]
  end

  delegate :name, to: :category, prefix: :category

  class << self
    def import_file file
      # get file to open
      spreadsheet = Roo::Spreadsheet.open file
      products = []

      # retrive column (column name)
      header = spreadsheet.row 1

      # each from row 2 to last
      (2..spreadsheet.last_row).each do |i|
        # add each array of row to products,
        products << spreadsheet.row(i)
      end
      import! header, products
    end
  end
end
