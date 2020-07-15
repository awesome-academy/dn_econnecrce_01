class StaticPagesController < ApplicationController
  skip_authorization_check

  def home
    @products = Product.top_product
  end
end
