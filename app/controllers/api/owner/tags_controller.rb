module Api
  module Owner
    class TagsController < ApplicationController
      before_action :authenticate_owner!

      def create
        tag = Tag.new(tag_params)

        if tag.save
          render json: serialize(tag), status: :created
        else
          render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
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

      def tag_params
        params.expect(tag: [ :name, :slug ])
      end

      def serialize(tag)
        {
          id: tag.id,
          name: tag.name,
          slug: tag.slug,
          created_at: tag.created_at,
          updated_at: tag.updated_at
        }
      end
    end
  end
end
