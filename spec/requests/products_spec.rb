require 'rails_helper'

RSpec.describe "ProductsRequests", type: :request do
  describe "GET #show" do
    let(:taxonomy) { create(:taxonomy) }
    let(:taxon) { create(:taxon, taxonomy: taxonomy) }
    let!(:product) { create(:product, slug: "potepan_product", taxons: [taxon]) }
    let!(:related_product) { create(:product, slug: "related_product", taxons: [taxon]) }

    context "HTTPで接続した時" do
      before do
        get potepan_product_path(product)
      end

      it "HTTPリクエストが成功する" do
        expect(response).to have_http_status(200)
      end

      it "productがセットされている" do
        expect(response.body).to include product.name
        expect(response.body).to include product.display_price.to_s
      end

      it "関連商品がセットされている" do
        expect(response.body).to include related_product.name
        expect(response.body).to include related_product.display_price.to_s
      end
    end

    context "Ajaxで接続した時" do
      before do
        get potepan_product_path(product), xhr: true, params: { id: product.slug }
      end

      it "Ajaxリクエストが成功する" do
        expect(response).to have_http_status(200)
      end
    end
  end
end
