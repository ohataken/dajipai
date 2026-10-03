module Api
  module Owner
    module Tags
      class CardsController < Api::OwnerController
        def index
          tag = Tag.find_by!(slug: params[:tag_slug])
          cards = tag.cards.includes(:tags)
          render json: {
            tag: {
              id: tag.id,
              name: tag.name,
              slug: tag.slug,
              created_at: tag.created_at,
              updated_at: tag.updated_at,
              cards: cards.map { |card| serialize(card) }
            }
          }
        end

        private

        def serialize(card)
          {
            id: card.id,
            uuid: card.uuid,
            name: card.name,
            pinyin: card.pinyin,
            syllables: card.pinyin_syllables,
            published_at: card.published_at,
            tags: card.tags.sort_by(&:slug).map { |tag| { slug: tag.slug, name: tag.name } },
            created_at: card.created_at,
            updated_at: card.updated_at
          }
        end
      end
    end
  end
end
