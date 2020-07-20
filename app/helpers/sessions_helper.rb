module SessionsHelper
  # store location in this time
  def store_location
    session[:forwarding_url] = request.original_url if request.post?
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def current_user? user
    user && user == current_user
  end

  # tinh total tien
  def total(quantity, unit_price)
    @total = quantity * unit_price
  end

  # duyet session to retrive id and quantity
  def find_product id
    @product = Product.find_by(id: id)
    return if @product

    flash[:danger] = t "products.text_error_not_found"
    redirect_to root_url
  end

  def sub_total
    sum = 0
    session[:cart].each do |id, quantity|
      find_product id
      sum += total(quantity, @product.unit_price)
    end
    sum
  end
end
