module Api
  module Owner
    class CardTagsController < Api::OwnerController
      def create
        card = Card.find_by!(uuid: params[:card_uuid])
        tag = Tag.find_by(slug: params[:tag_slug])

        unless tag
          render json: { errors: [ "Tag not found" ] }, status: :unprocessable_entity
          return
        end

        if card.tags.include?(tag)
          render json: serialize(card), status: :ok
        else
          card.tags << tag
          render json: serialize(card), status: :created
        end
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
