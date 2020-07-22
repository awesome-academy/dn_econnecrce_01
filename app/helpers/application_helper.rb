module ApplicationHelper
  def full_title page_title
    base_title = I18n.t "home_page.title_home"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def localize_datetime dtf
    dtf.strftime(I18n.t(:"dates.formats.date_month_year_concise", locale: I18n.locale))
  end

  def ld dtf
    localize_datetime(dtf)
  end

  def active_class category_id
    params[:id].to_i == category_id ? "link_select" : ""
  end

  def detail_purchase purchase
    @detailpurchases = purchase.detailpurchases
  end

  def quantity_purchase
    @detailpurchases.reduce(0){|total, detail| total + detail.quantity}
  end

  def total_purchase
    @detailpurchases.inject(0) do |tmp, detail|
      tmp += detail.quantity * detail.product.unit_price
    end
  end

  def transform value, number
    value.length <= number ? value : value.slice(0..number) + "..."
  end
end
