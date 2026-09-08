class Card < ApplicationRecord
  STATUSES = { draft: "draft", published: "published" }.freeze

  before_validation :fill_uuid

  has_many :card_tags, dependent: :destroy
  has_many :tags, through: :card_tags
  has_one :card_description, dependent: :destroy

  enum :status, STATUSES, validate: true

  validates :name, presence: true
  validates :pinyin, presence: true
  validates :uuid, presence: true, uniqueness: true

  private

  def fill_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
