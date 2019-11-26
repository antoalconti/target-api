class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :targets, dependent: :destroy

  enum gender: { female: 0, male: 1 }

  validates :full_name, presence: true
  validates :gender, presence: true, inclusion: { in: genders.keys }
end
