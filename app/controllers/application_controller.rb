class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_record_invalid(exception)
    render json: { errors: exception.record.errors.as_json }, status: :bad_request
  end

  def render_not_found
    render json: { error: I18n.t('api.errors.not_found') }, status: :not_found
  end
end
