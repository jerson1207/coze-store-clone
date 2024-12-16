class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart_items = current_user.cart.cart_items.includes(:product).select(:id, :product_id, :quantity)
    @favorite_products = current_user.favorited_products.pluck(:id)
  end
end
