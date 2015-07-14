class Employee < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :employee_tasks
  has_many :tasks, through: :employee_tasks
  has_many :inbox_proposals, class_name: Proposal, foreign_key: :receiver_id
  has_many :outbox_proposals, class_name: Proposal, foreign_key: :supplier_id


  def user_name
    user.name if user.present?
  end

  def in_control_tasks
    tasks.merge(EmployeeTask.in_control)
  end

  def active_tasks
    tasks.merge(EmployeeTask.in_active)
  end
end
