require 'rails_helper'

RSpec.describe "ProductsRequests", type: :request do
  describe "GET #show" do
    let!(:product) { create(:product, slug: "potepan_product") }

    it "HTTPリクエストが成功する" do
      get potepan_product_path(product)
      expect(response).to have_http_status(200)
    end

    it "Ajaxリクエストが成功する" do
      get potepan_product_path(product), xhr: true, params: { id: product.slug }
      expect(response).to have_http_status(200)
    end
  end
end
