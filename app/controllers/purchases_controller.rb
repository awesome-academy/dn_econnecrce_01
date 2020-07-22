class PurchasesController < ApplicationController
  load_and_authorize_resource param_method: :purchase_params
  before_action :authenticate_user!, except: %i(home index destroy)
  before_action :cart_is_empty?, only: %i(create new)

  def new
    @purchase = Purchase.new
  end

  def create
    ActiveRecord::Base.transaction do
      @purchase.save!
      add_products_to_detailspurchase @purchase.id
      @purchase.send_mail_to_customer current_user.email, session[:cart]
      session[:cart] = {}
      flash[:success] = t "checkout.add_success"
      redirect_to root_url
    rescue ActiveRecord::RecordInvalid
      render :new
    rescue => e
      flash[:danger] = t "checkout.errors_save"
      redirect_to root_url
    end
  end

  def edit; end

  def update
    @purchase.canceled!
    @purchases = current_user.purchases
                             .paginate(page: params[:page],
                                       per_page: Settings.per_page_purchase)
    flash[:success] = t "purchases.status_updated"
    respond_to do |format|
      format.html{redirect_to edit_purchase_url}
      format.js{flash.now[:success] = t("purchases.status_updated")}
    end
  rescue => e
    flash[:danger] = t "purchases.status_cant_update"
    respond_to do |format|
      format.html{redirect_to edit_purchase_url}
      format.js{flash.now[:notice] = t("purchases.status_cant_update")}
    end
  end

  private

  # insert details purchase in to details purchase
  def add_products_to_detailspurchase purchase_id
    session[:cart].each do |id, quantity|
      find_product id
      @product
        .detailpurchases
        .create(quantity: quantity, purchase_id: purchase_id)
    end
  end

  # check cart is emty?
  def cart_is_empty?
    return unless session[:cart].empty?

    store_location
    flash[:danger] = t "checkout.error_cart_empty"
    redirect_to products_path
  end

  # params purchases
  def purchase_params
    params.require(:purchase).permit(:name, :phone_number, :address, :status)
  end
end
