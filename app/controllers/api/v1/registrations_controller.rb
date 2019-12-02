module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      include Api::Concerns::ActAsApiRequest

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     :gender, :full_name)
      end

      def render_create_success
        render json: { user: resource_data }
      end
    end
  end
end
