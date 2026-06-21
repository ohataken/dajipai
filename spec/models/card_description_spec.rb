require 'rails_helper'

RSpec.describe CardDescription, type: :model do
  describe 'associations' do
    it 'belongs to a card' do
      card = Card.create!(name: '打', pinyin: 'dǎ')
      description = CardDescription.create!(card: card, content: 'to hit')

      expect(description.card).to eq(card)
    end
  end
end
