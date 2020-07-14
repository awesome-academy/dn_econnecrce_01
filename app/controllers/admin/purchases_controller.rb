class Admin::PurchasesController < AdminsController
  before_action :find_purchase, :user_signed_in?, only: %i(edit update)

  def index
    @purchases = Purchase.sorted
                         .paginate(page: params[:page],
                                   per_page: Settings.per_page_user)
    respond_to do |format|
      format.html
      format.xls{send_data @purchases.to_xls(col_sep: "\t"), filename: "Purchase-#{Time.zone.today}.xlsx"}
    end
  end

  def edit; end

  def update
    @purchase.update! status: purchase_params[:status].to_i
    flash[:success] = t "purchases.status_updated"
    redirect_to admin_purchases_path
  rescue => e
    flash[:danger] = t "purchases.status_cant_update"
    redirect_to admin_purchases_path
  end

  private

  def find_purchase
    @purchase = Purchase.find_by(id: params[:id])
    return if @purchase

    flash[:danger] = t "admin_purchases.text_not_found"
    redirect_to admin_purchases_url
  end

  def purchase_params
    params.require(:purchase).permit(:status)
  end
end
