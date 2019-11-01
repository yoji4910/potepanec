class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @option_types = @product.option_types.pluck(:name)
    # 指定したvariant || 指定なしvariant(firstがデフォルト) || is_master: falseがない商品
    @variant = @product.variants.includes(:images).find_by(id: params[:variant_id]) ||
                @product.variants.includes(:images).first ||
                @product

    # option valueをあるだけ 例)[["S", "M", "L", "XL"], ["Red", "Blue", "Green"]]
    @option_values = Array.new
    @option_types.each do |type|
      @option_values << variants_values(@product.variants.all, type)
    end
  end

  private
  def variants_values(variants, type)
    variants.map { |v| v.option_value(type) }.uniq
  end
end