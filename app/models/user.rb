class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
	validates :auth_token, uniqueness: true

  before_create :generate_authentication_token!

  def info
    "#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end

  def generate_authentication_token!
    self.auth_token = loop do
      token = Devise.friendly_token
      break token unless User.exists?(auth_token: token)
    end
  end
end
