module Api
  module V1
    class SiteInfosController < Api::V1::ApiController
      # def create
      #   @target = current_user..create!(target_params)
      # end

      def info
        @site_info = SiteInfo.last
        if @site_info.nil?
          render json: { error: I18n.t('api.models.site_info.no_info') }.to_json, status: 404
        else
          render :info
        end
      end
    end
  end
end
