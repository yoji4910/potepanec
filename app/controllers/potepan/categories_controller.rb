class Potepan::CategoriesController < ApplicationController
  def show
    # 商品カテゴリー用ルートカテゴリー取得
    @categories = Spree::Taxonomy.includes(:root)
    # 表示する商品を取得
    @taxon = Spree::Taxon.find(params[:id])
    @products = @taxon.products
  end
end
