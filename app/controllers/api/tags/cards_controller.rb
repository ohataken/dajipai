module Api
  module Tags
    class CardsController < ApplicationController
      def index
        tag = Tag.find_by!(slug: params[:tag_slug])
        cards = tag.cards.published.includes(:tags, :card_description)
        render json: {
          tag: {
            slug: tag.slug,
            name: tag.name,
            cards: cards.map { |card| serialize(card) }
          }
        }
      end

      private

      def serialize(card)
        {
          uuid: card.uuid,
          name: card.name,
          pinyin: card.pinyin,
          syllables: card.pinyin_syllables,
          tags: card.tags.sort_by(&:slug).map { |tag| { slug: tag.slug, name: tag.name } },
          card_description: card.card_description && { content: card.card_description.content }
        }
      end
    end
  end
end
