module Api
  module V1
    class ApiController < ApplicationController
      include Api::Concerns::ActAsApiRequest
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!

      respond_to :json
      layout false

      rescue_from Exception, with: :render_error
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActionController::RoutingError, with: :render_not_found

      private

      def render_error(exception)
        raise exception if Rails.env.test?

        # To properly handle RecordNotFound errors in views
        return render_not_found(exception) if exception.cause.is_a?(ActiveRecord::RecordNotFound)

        return if performed?

        render json: { error: I18n.t('api.errors.server') }, status: :internal_server_error
      end

      def render_record_invalid(exception)
        render json: { errors: exception.record.errors.as_json }, status: :bad_request
      end

      def render_not_found
        render json: { error: I18n.t('api.errors.not_found') }, status: :not_found
      end
    end
  end
end
