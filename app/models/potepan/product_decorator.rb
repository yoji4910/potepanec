module Potepan::ProductDecorator
  def related_products
    Spree::Product.
      in_taxons(taxons).
      where.not(id: id).
      distinct.includes(master: [:default_price, :images])
  end
  Spree::Product.prepend self
end
