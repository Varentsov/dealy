class Proposal < ActiveRecord::Base
  belongs_to :task
  belongs_to :supplier, class_name: Employee
  belongs_to :receiver, class_name: Employee

  after_create :create_employee_task
  before_destroy :delete_employee_task


  def create_employee_task
    EmployeeTask.create!(task_id: self.task_id, employee_id: receiver_id, role: EmployeeTask.roles[:reviewer], state: EmployeeTask.states[:prepare_to_delegate])
  end

  def delete_employee_task
    EmployeeTask.where(task_id: self.task_id, employee_id: receiver_id, role: EmployeeTask.roles[:reviewer], state: EmployeeTask.states[:prepare_to_delegate]).destroy_all
  end
end
