require 'rails_helper'

RSpec.describe '商品ページ', type: :system do
  let(:taxonomy) { create(:taxonomy, name: 'taxonomy') }
  let(:taxon1) { create(:taxon, taxonomy: taxonomy, parent_id: taxonomy.root.id) }
  let(:taxon2) { create(:taxon, taxonomy: taxonomy, parent_id: taxonomy.root.id) }
  let!(:product_of_taxon1) do
    create(:product,
           price: 100,
           description: "nice_bag",
           taxons: [taxon1])
  end
  let!(:product_of_taxon2) do
    create(:product,
           price: 200,
           description: "nice_shirt",
           taxons: [taxon2])
  end
  let!(:related_products_of_taxon1) { create_list(:product, 3, taxons: [taxon1]) }
  let!(:related_products_of_taxon2) { create_list(:product, 5, taxons: [taxon2]) }
  let!(:variant) { create(:variant, is_master: false, price: 100, product: product_of_taxon1) }

  describe '商品情報表示機能' do
    before do
      visit potepan_product_path(product_of_taxon1)
    end

    it "期待される商品の情報が表示される" do
      expect(page).to have_content product_of_taxon1.name
      expect(page).to have_content variant.display_price.to_s
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
        within '.productsContent' do
          expect(page.all('.productBox').size).to eq 3
          expect(page).to have_no_content product_of_taxon1.name
          expect(page).to have_no_content product_of_taxon1.display_price.to_s
        end
      end

      it "product_of_taxon1の非関連(taxon2の)商品が表示されない" do
        related_products_of_taxon2.each do |product|
          expect(find('.productsContent')).to have_no_content product.name
        end
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
        within '.productsContent' do
          expect(page.all('.productBox').size).to eq 4
          expect(page).to have_no_content product_of_taxon2.name
          expect(page).to have_no_content product_of_taxon2.display_price.to_s
        end
      end

      it "product_of_taxon2の非関連(taxon1の)商品が表示されない" do
        related_products_of_taxon1.each do |product|
          expect(find('.productsContent')).to have_no_content product.name
        end
      end

      it "関連商品に期待されるリンクがセットされている" do
        one_product = related_products_of_taxon2[0]
        click_on one_product.name
        expect(current_url).to eq potepan_product_url(one_product)
      end
    end
  end
end
