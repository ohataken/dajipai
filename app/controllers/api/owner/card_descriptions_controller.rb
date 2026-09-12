module Api
  module Owner
    class CardDescriptionsController < Api::OwnerController
      def show
        render json: serialize(find_card_description!)
      end

      private

      def card
        @card ||= Card.find_by!(uuid: params[:card_uuid])
      end

      def find_card_description!
        card.card_description || raise(ActiveRecord::RecordNotFound)
      end

      def serialize(card_description)
        {
          id: card_description.id,
          content: card_description.content,
          created_at: card_description.created_at,
          updated_at: card_description.updated_at
        }
      end
    end
  end
end
