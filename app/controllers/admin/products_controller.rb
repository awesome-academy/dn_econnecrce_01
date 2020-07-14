class Admin::ProductsController < AdminsController
  before_action :authenticate_user!, except: :index
  before_action :load_product, except: %i(create new index import)
  before_action :find_category, only: %i(create update)

  def index
    @products = Product.recent_product
                       .paginate(page: params[:page],
                                 per_page: Settings.per_page)
  end

  def import
    Product.import_file params[:file]
    flash[:success] = t "admin_products.text_imported"
    redirect_to admin_root_url
  rescue => e
    flash[:danger] = t "admin_products.text_error_excel"
    redirect_to admin_root_url
  end

  def new
    @product = Product.new
  end

  def create
    @product = @category.products.build product_params
    if @product.save
      flash[:success] = t "products.text_success_product"
      redirect_to admin_root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update product_params
      flash[:success] = t "edit_product.text_updated"
      redirect_to admin_root_url
    else
      render :edit
    end
  end

  private

  def find_category
    @category = Category.find_by(id: product_params[:category_id])
    return if @category

    flash[:danger] = t "products.text_error_category"
    redirect_to new_admin_product_path
  end

  def product_params
    params
      .require(:product)
      .permit(:name, :unit_price, :quantity, :image, :category_id, :description)
  end

  # check current user is admin?
  def admin_user
    redirect_to(root_url) unless current_user.role?
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "products.text_error_not_found"
    redirect_to admin_root_url
  end
end
