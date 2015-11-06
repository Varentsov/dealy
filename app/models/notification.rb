class Notification < ActiveRecord::Base
  belongs_to :employee

  scope :has_read, -> { where(has_read: true) }
  scope :hasnt_read, -> { where(has_read: false) }
end
