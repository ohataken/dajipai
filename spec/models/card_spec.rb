require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'associations' do
    it 'has one card description' do
      card = Card.create!(name: '打', pinyin: 'dǎ')
      description = CardDescription.create!(card: card, content: 'to hit')

      expect(card.card_description).to eq(description)
    end
  end

  describe '.published' do
    it 'returns cards published at or before now' do
      published = Card.create!(name: '打', pinyin: 'dǎ', published_at: 1.day.ago)
      Card.create!(name: '吃', pinyin: 'chī', published_at: 1.day.from_now)
      Card.create!(name: '喝', pinyin: 'hē')

      expect(Card.published).to contain_exactly(published)
    end
  end

  describe '.draft' do
    it 'returns cards without published_at' do
      Card.create!(name: '打', pinyin: 'dǎ', published_at: 1.day.ago)
      Card.create!(name: '吃', pinyin: 'chī', published_at: 1.day.from_now)
      draft = Card.create!(name: '喝', pinyin: 'hē')

      expect(Card.draft).to contain_exactly(draft)
    end
  end
end
