class Recipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  belongs_to :conversation
  belongs_to :author, foreign_key: :author_id, class_name: 'User'

  default_scope { where(:deleted => false) }


  def self.mark_as_read
    to_update = where(:read => false)
    if to_update.present?
      to_update.update_all(:read => true)
    end
  end
end
