module Api
  module Owner
    class CardDescriptionsController < Api::OwnerController
      def show
        render json: serialize(find_card_description!)
      end

      def create
        card_description = CardDescription.new(card_description_params)
        card_description.card = card

        if card_description.save
          render json: serialize(card_description), status: :created
        else
          render json: { errors: card_description.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
      end

      private

      def card
        @card ||= Card.find_by!(uuid: params[:card_uuid])
      end

      def find_card_description!
        card.card_description || raise(ActiveRecord::RecordNotFound)
      end

      def card_description_params
        params.expect(card_description: [ :content ])
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
