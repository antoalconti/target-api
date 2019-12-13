class TargetMatchingService
  def initialize(target)
    @target = target
  end

  def matches
    possible_matches.select do |target|
      matches?(target)
    end
  end

  private

  def matches?(target)
    Target.within((target.radius + @target.radius) / 1000.00, origin: target).include?(@target)
  end

  def possible_matches
    Target.where(topic_id: @target.topic_id).where.not(user_id: @target.user_id)
          .within(max_radius, origin: @target)
  end

  def max_radius
    (@target.radius + Target::MAX_RADIUS) / 1000.00
  end
end
