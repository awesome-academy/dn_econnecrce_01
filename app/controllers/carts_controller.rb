class CartsController < ApplicationController
  authorize_resource class: :cart

  def add_item
    session[:cart][params[:id]] ||= 0
    session[:cart][params[:id]] += 1
    flash[:success] = t "carts.cart_added"
    redirect_back_or products_path
  end

  def index; end

  def remove_from_cart
    session[:cart].delete(params[:id])
    flash[:success] = t "carts.cart_removed"
    redirect_to carts_path
  end
end
