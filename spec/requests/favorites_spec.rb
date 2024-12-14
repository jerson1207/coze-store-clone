require 'rails_helper'


RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let!(:product) { create(:product) }

  before do
    # Known issue with Devise's `sign_in` helper not working in request specs.
    # Using manual authentication via `post user_session_path` as a workaround for now.
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  describe "GET /favorites" do
    it "rreturns a list of the user's favorited products" do
      user.favorites.create(product: product)

      get favorites_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end
  end

  describe "POST favorites/:product_id/toggle" do
    context "when product is not favorited" do
      it "adds the product to the user's favorites" do
        expect {
          post toggle_favorite_path(product_id: product.id)
        }.to change { user.favorites.count }.by(1)
      end
    end
  end

  describe "DELETE /favorites/:id" do
    let!(:favorite) { user.favorites.create(product: product) }

    it "removes the product from the user's favorites" do
      expect {
        delete favorite_path(favorite)
      }.to change { user.favorites.count }.by(-1)

      expect(response).to redirect_to(favorites_path)
      follow_redirect!
      expect(response.body).to include("Favorite removed.")
    end
  end
end
