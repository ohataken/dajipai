class Card < ApplicationRecord
  before_validation :fill_uuid

  validates :name, presence: true
  validates :pinyin, presence: true
  validates :uuid, presence: true, uniqueness: true

  private

  def fill_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
