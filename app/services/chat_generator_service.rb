class ChatGeneratorService
  def initialize(current_user, matches)
    @current_user = current_user
    @matches = matches
  end

  def create
    @matches.each do |match|
      Chat.create!(user_a: @current_user, user_b: match.user) unless already_exists?(match.user)
    end
  end

  private

  def already_exists?(user)
    Chat.where(user_a: @current_user, user_b: user)
        .or(Chat.where(user_a: user, user_b: @current_user)).any?
  end
end
