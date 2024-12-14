class PagesController < ApplicationController
  def index
    @products = Product.includes(:categories)
    @categories = Category.pluck(:id, :name)
    @favorite_products = current_user ? current_user.favorited_products.pluck(:id) : []
  end
end
