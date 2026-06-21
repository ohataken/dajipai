module Api
  class CardsController < ApplicationController
    def index
      cards = Card.includes(:tags, :card_description).all
      render json: cards.map { |card| serialize(card) }
    end

    def show
      card = Card.includes(:tags).find_by!(uuid: params[:uuid])
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

    private

    def card_params
      params.expect(card: [ :name, :pinyin ])
    end

    def serialize(card)
      {
        uuid: card.uuid,
        name: card.name,
        pinyin: card.pinyin,
        tags: card.tags.sort_by(&:slug).map { |tag| { slug: tag.slug, name: tag.name } },
        card_description: card.card_description && { content: card.card_description.content }
      }
    end
  end
end
