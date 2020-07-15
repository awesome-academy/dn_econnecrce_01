class ProductsController < ApplicationController
  load_and_authorize_resource

  def index
    @products = Product.search(params[:term])
                       .paginate(page: params[:page],
                                 per_page: Settings.per_page_user)
    @categories = Category.sorted
  end

  def show; end
end
