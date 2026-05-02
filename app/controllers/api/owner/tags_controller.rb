module Api
  module Owner
    class TagsController < Api::OwnerController
      def create
        tag = Tag.new(tag_params)

        if tag.save
          render json: serialize(tag), status: :created
        else
          render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

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
