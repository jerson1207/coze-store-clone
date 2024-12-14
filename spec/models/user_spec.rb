require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:favorites).dependent(:destroy) }
  it { should have_many(:favorited_products).through(:favorites).source(:product) }
end
