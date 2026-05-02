class Tag < ApplicationRecord
  has_many :card_tags, dependent: :destroy
  has_many :cards, through: :card_tags

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
end
