require 'rails_helper'

RSpec.describe '商品ページ', type: :system do
  let!(:product1) { create(:product, name: "TEST PRODUCT", description: "very nice item") }

  let!(:product2) { create(:product) }

  let!(:variant) { create(:variant, is_master: false, product_id: product1.id, price: 11.11) }

  describe 'GET #show' do
    context "productがvariantをもつ時" do
      before do
        visit potepan_product_path(product1)
      end

      it "商品名が表示される" do
        expect(page).to have_content "TEST PRODUCT"
      end

      it "商品価格が表示される" do
        expect(page).to have_content "11.11"
      end

      it "商品説明が表示される" do
        expect(page).to have_content "very nice item"
      end

      it "optionのセレクトボックスが表示される" do
        expect(page).to have_css('#guiest_id3')
      end
    end

    context "productがvariantをもたない時" do
      it "optionのセレクトボックスが表示されない" do
        visit potepan_product_path(product2)
        expect(page).to have_no_css('#guiest_id3')
      end
    end
  end
end
