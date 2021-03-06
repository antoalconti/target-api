module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      include Api::Concerns::ActAsApiRequest

      private

      def resource_params
        params.require(:user).permit(:email, :password)
      end

      def render_create_success
        render json: { user: resource_data }
      end
    end
  end
end
