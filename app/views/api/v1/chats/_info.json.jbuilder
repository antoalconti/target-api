json.extract! chat, :id
json.user current_user == chat.user_a ? chat.user_b : chat.user_a, :id, :full_name
