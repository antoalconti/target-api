class RoomChannel < ApplicationCable::Channel
  def subscribed
    reject if params[:room_id].blank?
    stream_from("ChatRoom-#{params[:room_id]}")
  end

  def send_message(data)
    sender    = current_user
    room_id   = params[:room_id]
    message   = data['message']
    raise 'No room_id!' if room_id.blank?

    chat = get_chat(room_id)
    raise 'No message!' if message.blank?

    Message.create!(chat: chat, user: sender, text: message)
    payload = {
      room_id: room_id, content: message, sender: sender, participants: convo.users
    }
    ActionCable.server.broadcast("ChatRoom-#{room_id}", payload)
  end

  private

  def get_chat(room_code)
    Chat.find(room_code)
  end
end
