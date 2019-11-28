module Helpers
  def auth_headers
    user.create_new_auth_token
  end
end
