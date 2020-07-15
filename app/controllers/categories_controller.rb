class CategoriesController < ApplicationController
  authorize_resource
  before_action :find_category, only: :index

  def index
    @categories = Category.sorted
    @products = @category.products
                         .paginate(page: params[:page],
                                   per_page: Settings.per_page_user)
    render "products/index"
  end

  private

  def find_category
    @category = Category.find_by(id: params[:id])
    return if @category

    flash[:danger] = t "category.text_not_found"
    redirect_to products_url
  end
end
