class Message < ActiveRecord::Base
  has_many :recipients, dependent: :destroy
  has_many :users, through: :recipients
  validates :body, presence: true
end
