require 'rails_helper'

RSpec.describe "CategoriesRequests", type: :request do
  describe "GET #show" do
    let(:taxonomy) { create(:taxonomy, name: 'taxonomy') }
    let(:taxon) { create(:taxon, name: 'taxon', taxonomy: taxonomy, parent_id: taxonomy.root.id) }

    it "HTTPリクエストが成功する" do
      get potepan_category_path(taxon.id)
      expect(response).to have_http_status(200)
    end
  end
end
