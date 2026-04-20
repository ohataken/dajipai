class Card < ApplicationRecord
  validates :name, presence: true
  validates :pinyin, presence: true
  validates :uuid, presence: true, uniqueness: true
end
