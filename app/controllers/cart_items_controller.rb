class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def add_item
    @cart = current_user.cart || current_user.create_cart
    @cart_item = @cart.cart_items.find_or_initialize_by(product_id: params[:product_id])


    if @cart_item.new_record?
      @cart_item.save
      @action = "append"
    else
      @cart_item.increment!(:quantity)
      @action = "replace"
    end

    flash.now[:notice] = "Product has been added to your cart"

    respond_to do |format|
      format.turbo_stream
    end
  end

  def remove_item
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Product has been removed"
        render turbo_stream: [
          turbo_stream.remove("cart-item-#{@cart_item.id}"),
          turbo_stream.update("flash", partial: "layouts/flash")
        ]
      end
    end
  end

  def add_item_from_favorites
    @favorited_product = current_user.favorites.find_by(product_id: params[:product_id])
    @favorited_product.destroy
    @cart = current_user.cart || current_user.create_cart
    @cart_item = @cart.cart_items.find_or_initialize_by(product_id: params[:product_id])

    flash.now[:notice] = "Product has been added to your cart"

    if @cart_item.new_record?
      @cart_item.save
      @action = "append"
    else
      @cart_item.increment!(:quantity)
      @action = "replace"
    end

    flash.now[:notice] = "Product has been added to your cart"

    respond_to do |format|
      format.turbo_stream
    end
  end
end
