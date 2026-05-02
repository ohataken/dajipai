require 'rails_helper'

RSpec.describe CardTag, type: :model do
  let(:card) { Card.create!(name: "你好", pinyin: "nǐ hǎo") }
  let(:tag) { Tag.create!(name: "挨拶", slug: "greetings") }

  describe "associations" do
    it "associates a card with a tag" do
      CardTag.create!(card: card, tag: tag)
      expect(card.tags).to contain_exactly(tag)
      expect(tag.cards).to contain_exactly(card)
    end

    it "allows a card to have multiple tags" do
      other_tag = Tag.create!(name: "動詞", slug: "verbs")
      card.tags << tag
      card.tags << other_tag
      expect(card.tags).to contain_exactly(tag, other_tag)
    end

    it "allows a tag to be applied to multiple cards" do
      other_card = Card.create!(name: "再见", pinyin: "zài jiàn")
      tag.cards << card
      tag.cards << other_card
      expect(tag.cards).to contain_exactly(card, other_card)
    end
  end

  describe "uniqueness" do
    it "rejects duplicate (card, tag) pairs at the database level" do
      CardTag.create!(card: card, tag: tag)
      expect {
        CardTag.create!(card: card, tag: tag)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "dependent: :destroy" do
    it "removes join rows when a card is destroyed" do
      CardTag.create!(card: card, tag: tag)
      expect { card.destroy }.to change(CardTag, :count).by(-1)
      expect(Tag.exists?(tag.id)).to be true
    end

    it "removes join rows when a tag is destroyed" do
      CardTag.create!(card: card, tag: tag)
      expect { tag.destroy }.to change(CardTag, :count).by(-1)
      expect(Card.exists?(card.id)).to be true
    end
  end
end
