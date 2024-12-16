require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:favorites).dependent(:destroy) }
  it { should have_many(:favorited_products).through(:favorites).source(:product) }

  it { should have_one(:cart).dependent(:destroy) }

  describe 'callbacks' do
    it 'creates a cart after a user is created' do
      user = create(:user)

      expect(user.cart).to be_present
      expect(user.cart.user).to eq(user)
    end
  end
end
