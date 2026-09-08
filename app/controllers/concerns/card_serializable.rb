module CardSerializable
  extend ActiveSupport::Concern

  private

  def serialize_card(card)
    {
      uuid: card.uuid,
      name: card.name,
      pinyin: card.pinyin,
      status: card.status,
      tags: serialize_card_tags(card),
      card_description: serialize_card_description(card)
    }
  end

  def serialize_card_tags(card)
    card.tags.sort_by(&:slug).map { |tag| { slug: tag.slug, name: tag.name } }
  end

  def serialize_card_description(card)
    card.card_description && { content: card.card_description.content }
  end
end
