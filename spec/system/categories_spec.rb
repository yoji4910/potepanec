require 'rails_helper'

RSpec.describe 'カテゴリーページ', type: :system do
  describe 'カテゴリー表示機能' do
    let(:taxonomy) { create(:taxonomy, name: 'Categories') }
    # taxonomy所属の２つのtaxonを作成
    let(:taxon1) { create(:taxon, name: 'taxon1', taxonomy: taxonomy, parent: taxonomy.root) }
    let(:taxon2) { create(:taxon, name: 'taxon2', taxonomy: taxonomy, parent: taxonomy.root) }
    # taxon1所属のproduct
    let(:product1) { create(:product) }
    let(:product2) { create(:product) }
    # taxon2所属のproduct
    let(:product3) { create(:product) }

    before do
      product1.taxons << taxon1
      product2.taxons << taxon1
      product3.taxons << taxon2
    end

    context 'taxon1のカテゴリページに接続したとき' do
      before do
        visit potepan_category_path(taxon1.id)
      end

      it "light_sectionにtaxon1のnameが2ヵ所に表示される" do
        expect(find('.lightSection h2')).to have_content taxon1.name
        expect(find('.lightSection .breadcrumb')).to have_content taxon1.name
      end

      it "ルートカテゴリー(taxonomy)が表示される" do
        expect(page).to have_content taxonomy.name
      end

      it "taxonがそれぞれ表示される" do
        expect(page).to have_content taxon1.name
        expect(page).to have_content taxon2.name
      end

      it "taxon名の横のカウント数が表示される" do
        expect(all('.product_counter')[0]).to have_content "(#{taxon1.products.count})"
        expect(all('.product_counter')[1]).to have_content "(#{taxon2.products.count})"
      end

      it "taxon1の商品が表示される" do
        expect(page).to have_content product1.name
        expect(page).to have_content product2.name
        expect(page).to have_content product1.display_price
        expect(page).to have_content product2.display_price
      end
    end

    context 'taxon2のカテゴリページに接続した時' do
      before do
        visit potepan_category_path(taxon2.id)
      end

      it "light_sectionにtaxon2のnameが2ヵ所に表示される" do
        expect(find('.lightSection h2')).to have_content taxon2.name
        expect(find('.lightSection .breadcrumb')).to have_content taxon2.name
      end

      it "taxon1の商品が表示される" do
        expect(page).to have_content product3.name
        expect(page).to have_content product3.display_price
      end
    end
  end
end
