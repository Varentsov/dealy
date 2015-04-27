class Task < ActiveRecord::Base
  enum planning_state: [:to_sometime, :to_next, :to_today]
  validates :title, presence: true
  has_many :proposals
  has_many :employee_tasks
  has_many :employees, through: :employee_tasks
  #has_many :groups, through: :employees

  def delegate(from_employee_id, to_employee_id)
    EmployeeTask.unscoped.where(:employee_id => from_employee_id, :task_id => id).take.update_attributes(:employee_id => to_employee_id, :state => :active)
  end


  def over_deadline?
    true if deadline < Date.today
  end
end
