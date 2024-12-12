class PagesController < ApplicationController
  def index
    @products = Product.includes(:categories)
    @categories = Category.pluck(:id, :name)
  end
end
