require "spec_helper"
require "rails_helper"
require "byebug"
include SessionsHelper

describe Admin::ProductsController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    log_in @user
    logged_in_user
  end

  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET #edit" do
    let!(:product){FactoryBot.create(:product)}
    before {get :edit , params: {id: product}}

    context "show product to edit" do
      it {expect(assigns(:product)).to eq(product)}
    end

    context "render the #edit view" do
      it {expect(response).to render_template :edit}
    end

    it "flash error if product not found" do
      get :edit , params: {id: "aaa"}
      expect(flash[:danger]).to eq(I18n.t "products.text_error_not_found")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new product" do
        expect{
          post :create, params: {product: FactoryBot.attributes_for(:product)}
        }.to change(Product,:count).by(1)
      end
      it "flash success when product created" do
        post :create, params: {product: FactoryBot.attributes_for(:product)}
        expect(flash[:success]).to eq(I18n.t "products.text_success_product")
      end
      it "redirect to index" do
        post :create, params: {product: FactoryBot.attributes_for(:product)}
        expect(response).to redirect_to admin_root_url
      end
    end
    context "with invalid attributes" do
      it "does not save the new product"  do
        expect{
          post :create, params: {product: FactoryBot.attributes_for(:product, name: nil)}
        }.to_not change(Product, :count)
      end
      it "render new template"  do
        post :create, params: {product: FactoryBot.attributes_for(:product, name: nil)}
        expect(response).to render_template :new
      end
    end
  end
  describe "POST #update" do
    before {@product = FactoryBot.create(:product, name: "hot beer")}
    context "with valid attributes" do
      context "valid attributes" do
        it "located the requested @product" do
          put :update, params: { id: @product, product: FactoryBot.attributes_for(:product)}
          expect(assigns(:product)).to eq(@product)
        end
        it "changes @product's attributes" do
          put :update, params: { id: @product,
            product: FactoryBot.attributes_for(:product, name: "Beer Beer")}
          @product.reload
          @product.name.should eq("Beer Beer")
        end
        it "redirects to the updated product" do
          put :update, params: { id: @product, product: FactoryBot.attributes_for(:product)}
          expect(response).to redirect_to admin_root_url
        end
      end
    end
    context "with invalid attributes" do
      it "locates the requested @product" do
        put :update, params: { id: @product,
          product: FactoryBot.attributes_for(:product, name: nil)}
        expect(assigns(:product)).to eq(@product)
      end
      it "does not change @product's attributes" do
        put :update, params: { id: @product,
          product: FactoryBot.attributes_for(:product, name: nil)}
        @product.reload
        @product.name.should_not eq("Beer Beer")
      end
      it "re-renders the edit method" do
        put :update, params: { id: @product,
          product: FactoryBot.attributes_for(:product, name: nil)}
        expect(response).to render_template :edit
      end
    end
  end
end

