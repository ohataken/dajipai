module Api
  module Owner
    class CardsController < ApplicationController
      before_action :authenticate_owner!

      def create
        card = Card.new(card_params)

        if card.save
          render json: serialize(card), status: :created
        else
          render json: { errors: card.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def authenticate_owner!
        provided = request.authorization.to_s.sub(/\ABearer /, "")
        expected = owner_token

        unless expected.present? && ActiveSupport::SecurityUtils.secure_compare(provided, expected)
          render json: { errors: [ "Unauthorized" ] }, status: :unauthorized
        end
      end

      def owner_token
        ENV.fetch("OWNER_TOKEN", "")
      end

      def card_params
        params.expect(card: [ :name, :pinyin ])
      end

      def serialize(card)
        {
          id: card.id,
          uuid: card.uuid,
          name: card.name,
          pinyin: card.pinyin,
          created_at: card.created_at,
          updated_at: card.updated_at
        }
      end
    end
  end
end
