module Api
  module Tags
    class CardsController < ApplicationController
      include CardSerializable

      def index
        tag = Tag.find_by!(slug: params[:tag_slug])
        cards = tag.cards.published.includes(:tags, :card_description)
        render json: cards.map { |card| serialize_card(card) }
      end
    end
  end
end
