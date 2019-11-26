class Potepan::CategoriesController < ApplicationController
  def show
    @categories = Spree::Taxonomy.includes(:root)
    @taxon = Spree::Taxon.find(params[:id])
    @products = @taxon.all_products.includes(master: [:images, :default_price])
  end
end
