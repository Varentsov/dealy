class EmployeeTask < ActiveRecord::Base
  enum state: [:active, :delegated, :prepare_to_delegate]
  enum role: {author: 0, performer: 1, auditor: 2}
  belongs_to :task
  belongs_to :employee

  #default_scope { active }
  scope :in_control, -> { where(state: 2) }
  scope :in_active, -> { where(state: 0) }
end
