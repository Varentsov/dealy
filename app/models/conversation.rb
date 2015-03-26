class Conversation < ActiveRecord::Base
  has_many :recipients
  has_many :users, through: :recipients
  has_many :messages, through: :recipients
end
