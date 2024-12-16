require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should validate_presence_of(:name) }

  it { should have_and_belong_to_many(:categories) }

  it { should have_many(:favorites).dependent(:destroy) }
  it { should have_many(:favorited_by_users).through(:favorites).source(:user) }

  it { should have_many(:cart_items).dependent(:destroy) }
  it { should have_many(:carts).through(:cart_items) }
end
