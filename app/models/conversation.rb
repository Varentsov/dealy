class Conversation < ActiveRecord::Base
  has_many :recipients, dependent: :destroy
  has_many :users, through: :recipients
  has_many :messages, through: :recipients
  validates_presence_of :subject
end
