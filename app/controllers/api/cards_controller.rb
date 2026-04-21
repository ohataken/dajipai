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

    private

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
