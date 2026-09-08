module Api
  class CardsController < ApplicationController
    include CardSerializable

    def index
      cards = Card.published.includes(:tags, :card_description)
      render json: cards.map { |card| serialize_card(card) }
    end

    def show
      card = Card.published.includes(:tags).find_by!(uuid: params[:uuid])
      render json: serialize_card(card)
    end

    def create
      card = Card.new(card_params)

      if card.save
        render json: serialize_card(card), status: :created
      else
        render json: { errors: card.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def card_params
      params.expect(card: [ :name, :pinyin ])
    end
  end
end
