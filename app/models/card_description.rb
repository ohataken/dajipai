class CardDescription < ApplicationRecord
  belongs_to :card
  validates :content, presence: true
  validates :card, uniqueness: true
end
