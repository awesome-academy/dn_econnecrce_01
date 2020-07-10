require "spec_helper"
require "rails_helper"
require "byebug"
include SessionsHelper

RSpec.describe "admin/products/edit", type: :view do
  before do
    @user = FactoryBot.create(:user)
    log_in @user
    @product = Product.new
  end
  context "render template" do
    it "display form edit" do
      render
      view.should render_template(partial: "_form")
    end
    it "display error partial" do
      render
      view.should render_template(partial: "_error_messages")
    end
    it "display label name" do
      render
      expect(rendered).to have_selector("label", text: I18n.t("admin_products.text_name"))
    end
    it "display label category" do
      render
      expect(rendered).to have_selector("label", text: I18n.t("profile.tbl_category"))
    end
    it "display label quantity" do
      render
      expect(rendered).to have_selector("label", text: I18n.t("profile.tbl_quantity"))
    end
    it "display label price" do
      render
      expect(rendered).to have_selector("label", text: I18n.t("profile.tbl_unit_price"))
    end
  end
end

