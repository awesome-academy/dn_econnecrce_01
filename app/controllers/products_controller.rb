class ProductsController < ApplicationController
  load_and_authorize_resource

  def index
    @categories = Category.sorted
    @q = Product.ransack(params[:q])
    @products = @q.result
                 .paginate(page: params[:page],
                           per_page: Settings.per_page_user)
    @q.build_condition
  end

  def show; end
end
