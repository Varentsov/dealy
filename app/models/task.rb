class Task < ActiveRecord::Base
  enum planning_state: [:to_sometime, :to_next, :to_today]
  validates :title, presence: true
  has_many :employee_tasks
  has_many :employees, through: :employee_tasks

  def delegate(from_employee_id, to_employee_id)
    EmployeeTask.where(:employee_id => from_employee_id, :task_id => id).update_all(:employee_id => to_employee_id)
  end


  def over_deadline?
    true if deadline < Date.today
  end
end
