module Api
  module Owner
    module Cards
      class DraftsController < Api::OwnerController
        def index
          cards = Card.draft
          render json: cards.map { |card| serialize(card) }
        end

        def show
          card = Card.draft.find_by!(uuid: params[:uuid])
          render json: serialize(card)
        end

        private

        def serialize(card)
          {
            id: card.id,
            uuid: card.uuid,
            name: card.name,
            pinyin: card.pinyin,
            published_at: card.published_at,
            created_at: card.created_at,
            updated_at: card.updated_at
          }
        end
      end
    end
  end
end
