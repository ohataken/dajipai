class Card < ApplicationRecord
  before_validation :fill_uuid

  has_many :card_tags, dependent: :destroy
  has_many :tags, through: :card_tags
  has_one :card_description, dependent: :destroy

  scope :published, -> { where(published_at: ..Time.current) }
  scope :draft, -> { where(published_at: nil) }

  validates :name, presence: true
  validates :pinyin, presence: true
  validates :uuid, presence: true, uniqueness: true

  def draft?
    published_at.nil?
  end

  private

  def fill_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
