class PurchasesController < ApplicationController
  before_action :authenticate_user!, except: %i(home index destroy)
  before_action :cart_is_empty?, only: %i(create new)
  before_action :find_purchase, only: %i(edit update)

  def new
    @purchase = Purchase.new
  end

  def create
    ActiveRecord::Base.transaction do
      @purchase = current_user.purchases.build(purchase_params)
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
    @purchase.update! status: purchase_params[:status].to_i
    flash[:success] = t "purchases.status_updated"
    redirect_to edit_purchase_path
  rescue => e
    flash[:danger] = t "purchases.status_cant_update"
    redirect_to edit_purchase_path
  end

  private

  def find_purchase
    @purchase = current_user.purchases.find_by(id: params[:id])
    return if @purchase

    flash[:danger] = t "user_purchase.purchase_not_found"
    redirect_to user_path
  end

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
