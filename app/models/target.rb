class Target < ApplicationRecord
  belongs_to :topic

  validates :title, :radius, :latitude, :longitude, presence: true
  validates :radius, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }
end
