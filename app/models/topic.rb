class Topic < ApplicationRecord
  has_many :targets

  validates :name, presence: true, uniqueness: true
end
