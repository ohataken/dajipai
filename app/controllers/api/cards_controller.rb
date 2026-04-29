module Api
  class CardsController < ApplicationController
    def index
      cards = Card.all
      render json: cards.map { |card| serialize(card) }
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
      params.expect(card: [ :name, :pinyin ])
    end

    def serialize(card)
      {
        uuid: card.uuid,
        name: card.name,
        pinyin: card.pinyin
      }
    end
  end
end
