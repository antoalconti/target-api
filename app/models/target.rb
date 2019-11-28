class Target < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  MAX_TARGET_LIMIT = 10

  validates :title, :radius, :latitude, :longitude, presence: true
  validates :radius, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }
  validate :targets_per_user_limit, on: :create

  def targets_per_user_limit
    return if user.targets.size < MAX_TARGET_LIMIT

    errors.add(:target, I18n.t('api.models.target.errors.reached_limit', max: MAX_TARGET_LIMIT))
  end
end
