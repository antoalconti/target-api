class Chat < ApplicationRecord
  belongs_to :user_a,  class_name: 'User', foreign_key: 'user_a_id'
  belongs_to :user_b,  class_name: 'User', foreign_key: 'user_b_id'
  has_many :messages, dependent: :destroy

  def users
    [user_a, user_b]
  end

  def unread_messages_count(user)
    messages.unread_for(user).count
  end

  def clean_unread_messages(user)
    messages.unread_for(user).update_all(seen: true)
  end

  def other_user(user)
    user == user_a ? user_b : user_a
  end
end
