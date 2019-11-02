require 'rails_helper'

RSpec.describe "ProductsRequests", type: :request do
  describe "GET #show" do
    let!(:product) { create(:product) }
    it "responds successfully" do
      get potepan_product_path(product)
      expect(response).to have_http_status(200)
    end
  end
end
