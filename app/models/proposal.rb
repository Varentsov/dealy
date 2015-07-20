class Proposal < ActiveRecord::Base
  belongs_to :task
  belongs_to :supplier, foreign_key: 'supplier_id', class_name: 'Employee'
  belongs_to :receiver, foreign_key: 'receiver_id', class_name: 'Employee'

  after_create :create_employee_task
  before_destroy :delete_employee_task
  before_destroy :update_employee_task

  private

    def update_employee_task
      EmployeeTask.where(:employee_id => @proposal.supplier_id, :task_id => @proposal.task_id).take.update_attribute(:state, :active)
    end

    def create_employee_task
      EmployeeTask.create!(task_id: self.task_id, employee_id: receiver_id, role: EmployeeTask.roles[:reviewer], state: EmployeeTask.states[:prepare_to_delegate])
    end

    def delete_employee_task
      EmployeeTask.where(task_id: self.task_id, employee_id: receiver_id, role: EmployeeTask.roles[:reviewer], state: EmployeeTask.states[:prepare_to_delegate]).destroy_all
    end
end
