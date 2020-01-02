json.extract! user, :id, :full_name, :email, :gender
json.avatar user.avatar.attached? ? polymorphic_url(user.avatar) : nil
