class Employee < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :employee_tasks
  # There are 2 inefficient queries in associates
  has_many :tasks, through: :employee_tasks
  #has_many :tasks, -> { joins(:employee_tasks).where(:employee_tasks => {:state => EmployeeTask.states[:active]})},  through: :employee_tasks
  #has_many :in_control_tasks, -> { joins(:employee_tasks).where.not(:employee_tasks => {:state => EmployeeTask.states[:active]})}, through: :employee_tasks, source: :task
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
