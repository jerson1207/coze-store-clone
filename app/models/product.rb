class Product < ApplicationRecord
  validates :name, presence: true

  has_and_belongs_to_many :categories
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
end
