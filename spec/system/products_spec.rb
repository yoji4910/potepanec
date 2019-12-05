require 'rails_helper'

RSpec.describe '商品ページ', type: :system do
  let(:taxonomy) { create(:taxonomy, name: 'taxonomy') }
  let(:taxon1) { create(:taxon, name: 'bag', taxonomy: taxonomy, parent_id: taxonomy.root.id) }
  let(:taxon2) { create(:taxon, name: 'shirt', taxonomy: taxonomy, parent_id: taxonomy.root.id) }
  let(:product_of_taxon1) do
    create(:product,
           name: 'test_bag',
           price: 100,
           description: "nice_bag",
           taxons: [taxon1])
  end
  let(:product_of_taxon2) do
    create(:product,
           name: 'test_shirt',
           price: 200,
           description: "nice_shirt",
           taxons: [taxon2])
  end
  let(:related_products_of_taxon1) { create_list(:product, 3, taxons: [taxon1]) }
  let(:related_products_of_taxon2) { create_list(:product, 5, taxons: [taxon2]) }
  let(:variant) { create(:variant, is_master: false, price: 100) }

  before do
    related_products_of_taxon1.each.with_index(1) do |product, i|
      product.name = "#{taxon1.name}-#{i}"
      product.price = product_of_taxon1.price + i
      product.reload
    end

    related_products_of_taxon2.each.with_index(1) do |product, i|
      product.name = "#{taxon2.name}-#{i}"
      product.price = product_of_taxon2.price + i
      product.reload
    end

    product_of_taxon1.variants << variant
  end

  describe '商品情報表示機能' do
    before do
      visit potepan_product_path(product_of_taxon1)
    end

    it "商品名が表示される" do
      expect(page).to have_content product_of_taxon1.name
    end

    it "商品価格が表示される" do
      expect(page).to have_content variant.display_price.to_s
    end

    it "商品説明が表示される" do
      expect(page).to have_content product_of_taxon1.description
    end

    it "「一覧ページへ戻る」に所属カテゴリーへのリンクがセットされている" do
      click_on '一覧ページへ戻る'
      expect(current_url).to eq potepan_category_url(product_of_taxon1.taxon_ids[0])
    end
  end

  describe 'バリエーション選択ボックス表示機能' do
    context "productがvariantをもつ時" do
      it "optionのセレクトボックスが表示される" do
        visit potepan_product_path(product_of_taxon1)
        expect(page).to have_css('#guiest_id3')
      end
    end

    context "productがvariantをもたない時" do
      it "optionのセレクトボックスが表示されない" do
        visit potepan_product_path(product_of_taxon2)
        expect(page).to have_no_css('#guiest_id3')
      end
    end
  end

  describe '関連商品表示機能' do
    context '関連商品が3つ(4つ未満)の時' do
      before do
        visit potepan_product_path(product_of_taxon1)
      end

      it "product_of_taxon1の関連商品が3つ表示される" do
        expect(page.all('.productBox').size).to eq 3
      end

      it "product_of_taxon1の非関連(taxon2の)商品が表示されない" do
        related_products_of_taxon2.each do |product|
          expect(page).to have_no_content product.name
        end
      end

      it "product_of_taxon1自身が関連商品に表示されない" do
        expect(all('.productsContent h5')).to have_no_content product_of_taxon1.name
        expect(all('.productsContent h3')).to have_no_content product_of_taxon1.display_price.to_s
      end

      it "関連商品に期待されるリンクがセットされている" do
        one_product = related_products_of_taxon1[0]
        click_on one_product.name
        expect(current_url).to eq potepan_product_url(one_product)
      end
    end

    context '関連商品が5つ(4つ以上)の時' do
      before do
        visit potepan_product_path(product_of_taxon2)
      end

      it "product_of_taxon2の関連商品が4つ表示される" do
        expect(page.all('.productBox').size).to eq 4
      end

      it "product_of_taxon2の非関連(taxon1の)商品が表示されない" do
        related_products_of_taxon1.each do |product|
          expect(page).to have_no_content product.name
        end
      end

      it "product_of_taxon2自身が関連商品に表示されない" do
        expect(all('.productsContent h5')).to have_no_content product_of_taxon2.name
        expect(all('.productsContent h3')).to have_no_content product_of_taxon2.display_price.to_s
      end

      it "関連商品に期待されるリンクがセットされている" do
        one_product = related_products_of_taxon2[0]
        click_on one_product.name
        expect(current_url).to eq potepan_product_url(one_product)
      end
    end
  end
end
