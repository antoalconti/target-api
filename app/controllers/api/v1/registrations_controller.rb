module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :exception
      include Api::Concerns::ActAsApiRequest
      skip_before_action :check_json_request, on: :update
      before_action :check_form_or_json_request, on: :update

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     :gender, :full_name)
      end

      def render_create_success
        render 'api/v1/registrations/show'
      end

      def render_update_success
        render 'api/v1/registrations/show'
      end

      def account_update_params
        params.require(:user).permit(:gender, :full_name, :avatar)
      end
    end
  end
end
