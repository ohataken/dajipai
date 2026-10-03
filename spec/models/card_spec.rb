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

  describe '#draft?' do
    it 'returns true when published_at is nil' do
      expect(Card.new(published_at: nil)).to be_draft
    end

    it 'returns false when published_at is set' do
      expect(Card.new(published_at: 1.day.ago)).not_to be_draft
    end
  end

  describe '#pinyin' do
    it 'defaults to empty string' do
      expect(Card.new.pinyin).to eq('')
    end
  end

  describe '#pinyin_syllables' do
    it 'returns the syllable of each space-separated pinyin without tone marks' do
      card = Card.new(pinyin: 'hē zǎi miàn xiàn')

      expect(card.pinyin_syllables).to eq(%i[he zai mian xian].map { |letters| PinyinSyllable[letters] })
    end

    it 'reads tone marks written as combining characters' do
      expect(Card.new(pinyin: 'nǐ hǎo'.unicode_normalize(:nfd)).pinyin_syllables).to eq([ PinyinSyllable[:ni], PinyinSyllable[:hao] ])
    end

    it 'reads ü as v' do
      expect(Card.new(pinyin: 'lǜ').pinyin_syllables).to eq([ PinyinSyllable[:lv] ])
    end

    it 'ignores case' do
      expect(Card.new(pinyin: 'Nǐ').pinyin_syllables).to eq([ PinyinSyllable[:ni] ])
    end

    it 'returns no syllables for empty pinyin' do
      expect(Card.new(pinyin: '').pinyin_syllables).to eq([])
    end

    it 'skips what cannot be read as a syllable' do
      expect(Card.new(pinyin: 'tái běi / shì mào').pinyin_syllables).to eq(%i[tai bei shi mao].map { |letters| PinyinSyllable[letters] })
      expect(Card.new(pinyin: 'bv').pinyin_syllables).to eq([])
    end
  end

  describe 'pinyin validation' do
    it 'allows empty pinyin on a draft card' do
      expect(Card.create!(name: '打', pinyin: '')).to be_persisted
    end

    it 'rejects nil pinyin on a draft card' do
      expect(Card.new(name: '打', pinyin: nil)).not_to be_valid
    end

    it 'requires pinyin on a published card' do
      expect(Card.new(name: '打', pinyin: '', published_at: 1.day.ago)).not_to be_valid
      expect(Card.new(name: '打', pinyin: nil, published_at: 1.day.ago)).not_to be_valid
    end
  end
end
