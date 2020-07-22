class Admin::CategoriesController < AdminsController
  load_and_authorize_resource param_method: :category_params

  def index
    @categories = Category.recent_categories
                          .paginate(page: params[:page],
                                    per_page: Settings.per_page_user)
  end

  def new
    @category = Category.new
  end

  def create
    if @category.save
      flash[:success] = t "categories.added_success"
      redirect_to admin_categories_path
    else
      respond_to do |format|
        format.js
        format.json{render json: @category.errors, status: :unprocessable_entity}
      end
    end
  end

  def edit; end

  def update
    if @category.update category_params
      flash[:success] = t "categories.updated_category"
      redirect_to admin_categories_path
    else
      respond_to do |format|
        format.js
        format.json{render json: @category.errors, status: :unprocessable_entity}
      end
    end
  end

  private

  def category_params
    params
      .require(:category)
      .permit(:name, products_attributes: [:id, :name, :quantity, :unit_price, :description, :image])
  end
end
