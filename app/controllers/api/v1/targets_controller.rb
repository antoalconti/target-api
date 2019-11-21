module Api
  module V1
    class TargetsController < ApplicationController
      def create
        @target = Target.create!(target_params)
        render :show, status: :created
      end

      def show
        @target = Target.find(params[:id])
      end

      private

      def target_params
        params.require(:target).permit(:topic_id, :title, :radius, :latitude, :longitude)
      end
    end
  end
end
