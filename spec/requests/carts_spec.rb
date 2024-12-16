require 'rails_helper'

RSpec.describe "Cart", type: :request do
  let(:user) { create(:user) }
  let!(:product) { create(:product) }

  describe 'Get /cart' do
    context "when the user is authorized" do
      it "renders the cart page without needing to create a new cart by default" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }

        get cart_path

        expect(response).to have_http_status(:success)
      end
    end

    context "when the usr is not authorized" do
      it "redirect to login page" do
        get cart_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
