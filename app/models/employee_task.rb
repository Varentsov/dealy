class EmployeeTask < ActiveRecord::Base
  enum state: [:active, :delegating]
  belongs_to :task
  belongs_to :employee

  default_scope { active }
end
