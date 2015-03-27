class Message < ActiveRecord::Base
  has_many :recipients, dependent: :destroy
  has_many :users, through: :recipients
  has_many :conversations, through: :recipients
  validates :body, presence: true
end
