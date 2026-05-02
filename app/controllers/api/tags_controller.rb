module Api
  class TagsController < ApplicationController
    def index
      tags = Tag.order(:slug)
      render json: tags.map { |tag| serialize(tag) }
    end

    private

    def serialize(tag)
      {
        slug: tag.slug,
        name: tag.name
      }
    end
  end
end
