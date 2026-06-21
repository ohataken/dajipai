module Api
  class CardDescriptionsController < ApplicationController
    def show
      render json: serialize(card_description_for!(card))
    end

    def create
      card_description = card.card_description || card.build_card_description
      created = card_description.new_record?

      if card_description.update(card_description_params)
        render json: serialize(card_description), status: created ? :created : :ok
      else
        render json: { errors: card_description.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      card_description = card_description_for!(card)

      if card_description.update(card_description_params)
        render json: serialize(card_description)
      else
        render json: { errors: card_description.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def card
      @card ||= Card.find_by!(uuid: params[:card_uuid])
    end

    def card_description_for!(card)
      card.card_description || raise(ActiveRecord::RecordNotFound)
    end

    def card_description_params
      params.expect(card_description: [ :content ])
    end

    def serialize(card_description)
      {
        content: card_description.content
      }
    end
  end
end
