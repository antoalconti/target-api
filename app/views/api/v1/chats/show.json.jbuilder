json.chat @chat, partial: 'info', as: :chat
json.chat_messages @chat.messages, :user_id, :text
