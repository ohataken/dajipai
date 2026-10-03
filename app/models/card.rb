class Card < ApplicationRecord
  PINYIN_TONE_MARKS = [ 0x304, 0x301, 0x30C, 0x300 ].pack("U*").freeze

  before_validation :fill_uuid

  has_many :card_tags, dependent: :destroy
  has_many :tags, through: :card_tags
  has_one :card_description, dependent: :destroy

  attribute :pinyin, :string, default: ""

  scope :published, -> { where(published_at: ..Time.current) }
  scope :draft, -> { where(published_at: nil) }

  validates :name, presence: true
  validates :pinyin, presence: true, unless: :draft?
  validates :pinyin, exclusion: { in: [ nil ], message: "can't be nil" }, if: :draft?
  validates :uuid, presence: true, uniqueness: true

  def draft?
    published_at.nil?
  end

  def pinyin_syllables
    letters = pinyin.unicode_normalize(:nfd).delete(PINYIN_TONE_MARKS).unicode_normalize(:nfc).downcase.tr("ü", "v")
    letters.split.filter_map { |syllable| PinyinSyllable::ALL[syllable.to_sym] }
  end

  private

  def fill_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
