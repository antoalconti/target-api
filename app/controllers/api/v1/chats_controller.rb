module Api
  module V1
    class ChatsController < Api::V1::ApiController
      def index
        @chats = current_user.chats
      end

      def show
        @chat = Chat.find(params[:id])
      end
    end
  end
end
