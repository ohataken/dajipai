require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'associations' do
    it 'has one card description' do
      card = Card.create!(name: '打', pinyin: 'dǎ')
      description = CardDescription.create!(card: card, content: 'to hit')

      expect(card.card_description).to eq(description)
    end
  end
end
