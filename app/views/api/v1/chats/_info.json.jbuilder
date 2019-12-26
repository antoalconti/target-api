json.id chat.id
json.unread_messages chat.unread_messages_count(current_user)
json.user current_user == chat.user_a ? chat.user_b : chat.user_a, :id, :full_name
