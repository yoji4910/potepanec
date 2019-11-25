require 'rails_helper'

RSpec.describe "CategoriesRequests", type: :request do
  describe "GET #show" do
    let(:taxonomy) { create(:taxonomy, name: 'taxonomy') }
    let(:taxon) { create(:taxon, name: 'taxon', taxonomy: taxonomy, parent_id: taxonomy.root.id) }
    let(:product) { create(:product) }

    before do
      product.taxons << taxon
    end

    context '存在するtaxon_idのカテゴリページに接続した時' do
      before do
        get potepan_category_path(taxon.id)
      end

      it "HTTPリクエストが成功する" do
        expect(response).to have_http_status(200)
      end

      it "カテゴリ名が表示される" do
        expect(response.body).to include taxonomy.name
        expect(response.body).to include taxon.name
      end

      it "商品名と価格が表示される" do
        expect(response.body).to include product.name
        expect(response.body).to include product.display_price.to_s
      end
    end

    context '存在しないtaxon_idのカテゴリページに接続した時' do
      subject { -> { get potepan_category_path(taxon.id + 1) } }

      it "ActiveRecord::RecordNotFoundエラーが発生する" do
        is_expected.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
