class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorites, dependent: :destroy
  has_many :favorited_products, through: :favorites, source: :product

  has_one :cart, dependent: :destroy  # Ensure cart is destroyed when user is deleted

  after_create :create_cart

  private

  def create_cart
    self.create_cart! # This will create an associated cart for the user
  end
end
