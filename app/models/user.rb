class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :targets, dependent: :destroy
  has_one_attached :avatar

  enum gender: { female: 0, male: 1 }

  validates :full_name, presence: true
  validates :gender, presence: true, inclusion: { in: genders.keys }

  def chats
    Chat.where(user_a_id: id).or(Chat.where(user_b_id: id))
  end
end
