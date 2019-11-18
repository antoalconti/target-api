class Topic < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
