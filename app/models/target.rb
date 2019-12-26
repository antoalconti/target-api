class Target < ApplicationRecord
  belongs_to :topic
  belongs_to :user
  acts_as_mappable default_units: :kms,
                   default_formula: :flat,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  MAX_TARGET_LIMIT = 10
  MAX_RADIUS = 1000

  validates :title, :radius, :latitude, :longitude, presence: true
  validates :radius, numericality: { greater_than: 0, less_than_or_equal_to: MAX_RADIUS }
  validate :targets_per_user_limit, on: :create

  def targets_per_user_limit
    return if user.targets.size < MAX_TARGET_LIMIT

    errors.add(:target, I18n.t('api.models.target.errors.reached_limit', max: MAX_TARGET_LIMIT))
  end
end
