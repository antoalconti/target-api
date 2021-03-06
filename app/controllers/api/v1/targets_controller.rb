module Api
  module V1
    class TargetsController < Api::V1::ApiController
      def new
        @topics = Topic.all
      end

      def create
        @target = current_user.targets.create!(target_params)
        @target_matches = TargetMatchingService.new(@target).matches
        ChatGeneratorService.new(current_user, @target_matches).create
        render :show, status: :created
      end

      def destroy
        Target.destroy(params[:id])
      end

      def show
        @target = Target.find(params[:id])
        @target_matches = TargetMatchingService.new(@target).matches
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
