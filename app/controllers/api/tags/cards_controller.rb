module Api
  module Tags
    class CardsController < ApplicationController
      def index
        tag = Tag.find_by!(slug: params[:tag_slug])
        cards = tag.cards.includes(:tags)
        render json: cards.map { |card| serialize(card) }
      end

      private

      def serialize(card)
        {
          uuid: card.uuid,
          name: card.name,
          pinyin: card.pinyin,
          tags: card.tags.sort_by(&:slug).map { |tag| { slug: tag.slug, name: tag.name } }
        }
      end
    end
  end
end
