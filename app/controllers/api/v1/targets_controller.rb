module Api
  module V1
    class TargetsController < Api::V1::ApiController
      def create
        @target = current_user.targets.create!(target_params)
        render :show, status: :created
      end

      def destroy
        Target.destroy(params[:id])
        render json: { message: I18n.t('api.models.target.deleted') }
      end

      def show
        @target = Target.find(params[:id])
      end

      def index
        @targets = current_user.targets
      end

      private

      def target_params
        params.require(:target).permit(:topic_id, :title, :radius, :latitude, :longitude)
      end
    end
  end
end
