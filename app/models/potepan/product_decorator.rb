module Potepan::ProductDecorator
  RELATED_PRODUCTS_LIMIT_NUMBER = 4
  def related_products
    Spree::Product.
      in_taxons(taxons).
      where.not(id: id).
      distinct.includes(master: [:default_price, :images]).
      limit(RELATED_PRODUCTS_LIMIT_NUMBER)
  end
  Spree::Product.prepend self
end
