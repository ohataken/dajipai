require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'associations' do
    it 'has one card description' do
      card = Card.create!(name: '打', pinyin: 'dǎ')
      description = CardDescription.create!(card: card, content: 'to hit')

      expect(card.card_description).to eq(description)
    end
  end

  describe 'status' do
    it 'starts as a draft' do
      expect(Card.create!(name: '打', pinyin: 'dǎ')).to be_draft
    end

    it 'rejects an unknown status' do
      card = Card.new(name: '打', pinyin: 'dǎ', status: 'bogus')

      expect(card).not_to be_valid
      expect(card.errors[:status]).to be_present
    end

    it 'lists only published cards in the published scope' do
      published = Card.create!(name: '打', pinyin: 'dǎ', status: :published)
      Card.create!(name: '吃', pinyin: 'chī', status: :draft)

      expect(Card.published).to eq([ published ])
    end
  end
end
