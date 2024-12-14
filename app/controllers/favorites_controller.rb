class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: :toggle

  def index
    @favorites = current_user.favorited_products
  end

  def toggle
    favorite = current_user.favorites.find_by(product: @product)
    if favorite
      favorite.destroy
      render json: { status: "removed" }
    else
      current_user.favorites.create(product: @product)
      render json: { status: "added" }
    end
  end

  def destroy
    favorite = current_user.favorites.find_by(product_id: params[:id])
    favorite.destroy
    respond_to do |format|
      format.turbo_stream do
        if current_user.favorites.blank?
          render turbo_stream: turbo_stream.replace("favorites", partial: "no_favorites")
        else
          render turbo_stream: turbo_stream.remove("favorite_#{favorite.product_id}")
        end
      end
      format.html { redirect_to favorites_path, notice: "Favorite removed." }
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
end
