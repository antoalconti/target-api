module Api
  module Concerns
    module ActAsApiRequest
      extend ActiveSupport::Concern

      included do
        before_action :check_json_request
      end

      def check_json_request
        return if request_content_type&.match?(/json/)

        render json: { error: I18n.t('api.errors.invalid_content_type') }, status: :not_acceptable
      end

      def request_content_type
        request.content_type
      end
    end
  end
end
