class RoomChannel < ApplicationCable::Channel
  def subscribed
    raise I18n.t('api.channels.room_channel.errors.no_chat_id') if params[:room_id].blank?

    stream_from("ChatRoom-#{params[:room_id]}")
    connect
  end

  def send_message(data)
    room_id   = params[:room_id]
    message   = data['message']
    raise I18n.t('api.channels.room_channel.errors.no_chat_id') if room_id.blank?

    raise I18n.t('api.channels.room_channel.errors.no_message') if message.blank?

    create_message(room_id, message)
  end

  def unsubscribed
    is_user_a = (current_user == chat.user_a)
    is_user_a ? chat.update(user_a_connected: false) : chat.update(user_b_connected: false)
  end

  private

  def create_message(room_id, message)
    Message.create!(chat: chat, user: current_user, text: message, seen: other_user_connected?)
    ActionCable.server.broadcast("ChatRoom-#{room_id}", payload(room_id, message))
  end

  def payload(room_id, message)
    { room_id: room_id, content: message, sender: current_user, participants: chat.users }
  end

  def chat
    @chat ||= Chat.find(params[:room_id])
  end

  def other_user_connected?
    current_user == chat.user_a && chat.user_b_connected ||
      current_user == chat.user_b && chat.user_a_connected
  end

  def connect
    is_user_a = (current_user == chat.user_a)
    is_user_a ? chat.update(user_a_connected: true) : chat.update(user_b_connected: true)
  end
end
