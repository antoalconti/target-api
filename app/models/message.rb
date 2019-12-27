class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :text, presence: true
  validate :user_belongs_to_chat, on: :create

  scope :unread_for, ->(user) { where(seen: false).where.not(user_id: user.id) }

  private

  def user_belongs_to_chat
    return if chat.user_a == user || chat.user_b == user

    errors.add(:message, I18n.t('api.models.message.errors.chat_different_users'))
  end
end
