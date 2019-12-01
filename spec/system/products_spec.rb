require 'rails_helper'

RSpec.describe '商品ページ', type: :system do
  let(:taxonomy) { create(:taxonomy, name: 'taxonomy') }
  let(:taxon1) { create(:taxon, name: 'taxon1', taxonomy: taxonomy, parent_id: taxonomy.root.id) }
  let(:taxon2) { create(:taxon, name: 'taxon2', taxonomy: taxonomy, parent_id: taxonomy.root.id) }
  (1..3).each do |i|
    price = i * 100
    let("product#{i}".to_sym) do
      create(
        :product,
        name: "Test_product_#{i}",
        price: price,
        description: "nice_item_#{i}"
      )
    end
  end
  let(:variant) { create(:variant, is_master: false, product_id: product1.id, price: 100) }

  before do
    product1.taxons << taxon1
    product2.taxons << taxon2
    product3.taxons << taxon1
  end

  describe 'GET #show' do
    context "productがvariantをもつ時" do
      before do
        visit potepan_product_path(product1)
      end

      it "商品名が表示される" do
        expect(page).to have_content product1.name
      end

      it "商品価格が表示される" do
        expect(page).to have_content variant.display_price.to_s
      end

      it "商品説明が表示される" do
        expect(page).to have_content product1.description
      end

      it "optionのセレクトボックスが表示される" do
        expect(page).to have_css('#guiest_id3')
      end

      it "product1の関連(同一toxon_id)商品が表示される" do
        expect(page).to have_content product3.name
        expect(page).to have_content product3.display_price.to_s
      end

      it "product1の非関連(異なるtoxon_id)商品が表示されない" do
        expect(page).to have_no_content product2.name
        expect(page).to have_no_content product2.display_price.to_s
      end

      it "product1自身が関連商品に表示されない" do
        expect(find('.productsContent h5')).to have_no_content product1.name
        expect(find('.productsContent h3')).to have_no_content product1.display_price.to_s
      end

      it "関連商品に期待されるリンクがセットされている" do
        click_on product3.name
        expect(current_url).to eq potepan_product_url(product3)
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
