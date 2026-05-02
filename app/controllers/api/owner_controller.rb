module Api
  class OwnerController < ApplicationController
    before_action :authenticate_owner!

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
  end
end
