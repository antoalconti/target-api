module Api
  module V1
    class ChatsController < Api::V1::ApiController
      def index
        @chats = current_user.chats
      end

      def show
        @chat = Chat.find(params[:id])
        @chat.clean_unread_messages(current_user)
      end
    end
  end
end
