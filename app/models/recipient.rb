class Recipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  belongs_to :conversation
  belongs_to :author, foreign_key: :author_id

  default_scope { where(:deleted => false) }
end
