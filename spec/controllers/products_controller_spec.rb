require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe "#show" do
    let!(:product) { create(:product) }
    # 正常にレスポンスを返す
    it "responds successfully" do
      get :show, params: { id: product_id }
      expect(responce).to be_success
    end
  end
end
