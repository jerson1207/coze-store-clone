FactoryBot.define do
  factory :cart_item do
    association :cart
    association :product
  end
end
