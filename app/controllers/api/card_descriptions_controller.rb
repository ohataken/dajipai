module Api
  class CardDescriptionsController < ApplicationController
    def show
      render json: serialize(card_description_for!(card))
    end

    private

    def card
      @card ||= Card.find_by!(uuid: params[:card_uuid])
    end

    def card_description_for!(card)
      card.card_description || raise(ActiveRecord::RecordNotFound)
    end

    def serialize(card_description)
      {
        content: card_description.content
      }
    end
  end
end
