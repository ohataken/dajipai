module Api
  module Owner
    class CardsController < Api::OwnerController
      include CardSerializable

      def index
        cards = Card.includes(:tags, :card_description).order(created_at: :desc)
        cards = cards.where(status: params[:status]) if Card.statuses.key?(params[:status])
        render json: cards.map { |card| serialize(card) }
      end

      def show
        card = Card.includes(:tags, :card_description).find_by!(uuid: params[:uuid])
        render json: serialize(card)
      end

      def create
        card = Card.new(card_params)

        if card.save
          render json: serialize(card), status: :created
        else
          render json: { errors: card.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        card = Card.find_by!(uuid: params[:uuid])

        if card.update(card_params)
          render json: serialize(card)
        else
          render json: { errors: card.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def card_params
        params.expect(card: [ :name, :pinyin, :status ])
      end

      def serialize(card)
        serialize_card(card).merge(
          id: card.id,
          created_at: card.created_at,
          updated_at: card.updated_at
        )
      end
    end
  end
end
