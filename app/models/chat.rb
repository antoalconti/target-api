class Chat < ApplicationRecord
  belongs_to :user_a,  class_name: 'User', foreign_key: 'user_a_id'
  belongs_to :user_b,  class_name: 'User', foreign_key: 'user_b_id'
  has_many :messages, dependent: :destroy

  def users
    [user_a, user_b]
  end

  def unread_messages_count(user)
    messages.where(seen: false).where.not(user: user).count
  end
end
