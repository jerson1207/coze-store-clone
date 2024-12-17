require "rails_helper"

RSpec.describe "Cart Items Management", type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:headers) { { 'ACCEPT' => 'text/vnd.turbo-stream.html' } }

  before do
    # Simulate user login
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  describe "POST /cart_items/:product_id/add_item" do
    context "when the cart item does not exist" do
      it "adds the item to the cart" do
        expect {
          post add_item_cart_items_path(product_id: product.id), headers: headers
        }.to change { CartItem.count }.by(1)

        cart_item = CartItem.last
        expect(cart_item.quantity).to eq(1)
        expect(cart_item.product.name).to eq(product.name)

        # Assert Turbo Stream response
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("turbo-stream") # Check Turbo Stream structure
        expect(response.body).to include("<turbo-stream action=\"append\"")

        # flash
        expect(response.body).to include('Product has been added to your cart')
      end
    end

    context "when a product is added to the cart from the favorites page" do
      it "removes the product from favorites and adds it to the cart" do
        favorited_product = Favorite.create(user: user, product: product)

        get favorites_path

        # Ensure product exists in favorites
        expect(response.body).to include(product.name)

        expect {
          post add_item_from_favorites_cart_items_path(product_id: product.id), headers: headers
        }.to change { user.favorited_products.count }.by(-1)
          .and change { user.cart.cart_items.count }.by(1)

        # Assert Turbo Stream response
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("turbo-stream") # Check Turbo Stream structure
        expect(response.body).to include("<turbo-stream action=\"replace\"")

        # Favorites Section Should Not Include Product
        expect(response.body).to include('Product has been added to your cart')
      end
    end

    context "when the cart item already exists" do
      it "increments the cart item quantity" do
        cart_item = user.cart.cart_items.create(product: product)

        post add_item_cart_items_path(product_id: product.id), headers: headers

        expect(cart_item.reload.quantity).to eq(2)

        # Assert Turbo Stream response
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("turbo-stream") # Check Turbo Stream structure
        expect(response.body).to include("<turbo-stream action=\"replace\"")

        # Flash
        expect(response.body).to include('Product has been added to your cart')
      end
    end
  end

  describe "DELETE /cart_items/:id/remove_item" do
    it "remove the cart item from cart" do
      cart_item = user.cart.cart_items.create(product: product)

      expect {
        delete remove_item_cart_items_path(cart_item.id), headers: headers
      }.to change { CartItem.count }.by(-1)

      expect(response.body).to include('Product has been removed')

      # Assert Turbo Stream response
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream") # Check Turbo Stream structure
      expect(response.body).to include("<turbo-stream action=\"remove\"")
    end
  end
end
