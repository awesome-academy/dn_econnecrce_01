class Admin::CategoriesController < AdminsController
  load_and_authorize_resource param_method: :category_params
  before_action :load_category, only: :new

  def new
    @category = Category.new
  end

  def create
    respond_to do |format|
      if @category.save
        format.js{flash.now[:notice] = t("categories.added_success")}
      else
        format.js
        format.json{render json: @category.errors, status: :unprocessable_entity}
      end
    end
  end

  private

  def load_category
    @categories = Category.recent_categories
                          .paginate(page: params[:page],
                                    per_page: Settings.per_page_user)
  end

  def category_params
    params
      .require(:category)
      .permit(:name, products_attributes: [:name, :quantity, :unit_price, :description])
  end
end
