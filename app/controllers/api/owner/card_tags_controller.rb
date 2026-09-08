module Api
  module Owner
    class CardTagsController < Api::OwnerController
      include CardSerializable

      def create
        card = Card.find_by!(uuid: params[:card_uuid])
        tag = Tag.find_by(slug: params[:tag_slug])

        unless tag
          render json: { errors: [ "Tag not found" ] }, status: :unprocessable_entity
          return
        end

        if card.tags.include?(tag)
          render json: serialize_card(card), status: :ok
        else
          card.tags << tag
          render json: serialize_card(card), status: :created
        end
      end

      def destroy
        card = Card.find_by!(uuid: params[:card_uuid])
        tag = Tag.find_by(slug: params[:slug])
        card.tags.delete(tag) if tag
        head :no_content
      end
    end
  end
end
