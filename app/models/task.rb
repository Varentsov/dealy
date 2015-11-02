class Task < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  enum planning_state: [:to_sometime, :to_next, :to_today]
  validates :title, presence: true
  has_many :proposals, dependent: :destroy
  has_many :employee_tasks, dependent: :destroy
  has_many :employees, through: :employee_tasks
  #has_many :groups, through: :employees

  def delegate(from_employee_id, to_employee_id)
    from_em_task = EmployeeTask.where(:employee_id => from_employee_id, :task_id => id).take
    if from_em_task.author?
      from_em_task.update_attributes(:state => :delegated)
    else
      from_em_task.update_attributes(:state => :delegated, :role => :reviewer)
    end
    EmployeeTask.create!(:task_id => id, :employee_id => to_employee_id, :state => :active, :role => :performer)
  end

  def over_deadline?
    true if deadline < Date.today
  end

  def prepare_to_delegate(from_employee_id, to_employee_id)
    to_employee = Employee.find(to_employee_id)
    if to_employee.is_group?
      proposal = Proposal.create!(:task_id => id, :supplier_id => from_employee_id, :to_group => true ,:receiver_id => to_employee.group.roles.find_by_name('Приемщик заявок').employees.take.id)
      emp_task = Employee.find(from_employee_id).employee_tasks.where(:task_id => id).take.update_attribute(:state, :prepare_to_delegate)
      Notification.create!(:employee_id => to_employee.group.roles.find_by_name('Приемщик заявок').employees.take.id, text: "<a href=\"#{user_path(Employee.find(from_employee_id).user)}\">#{Employee.find(from_employee_id).user.name}</a> прислал заявку на задачу <a href=\"#{task_path(self.id)}\">#{self.title}</a>")
    else
      proposal = Proposal.create!(:task_id => id, :supplier_id => from_employee_id, :receiver_id => to_employee_id)
      emp_task = Employee.find(from_employee_id).employee_tasks.where(:task_id => id).take.update_attribute(:state, :prepare_to_delegate)
      Notification.create!(:employee_id => to_employee_id, text: "<a href=\"#{user_path(Employee.find(from_employee_id).user)}\">#{Employee.find(from_employee_id).user.name}</a> прислал заявку на задачу <a href=\"#{proposal_path(proposal.id)}\">#{self.title}</a>")
    end
  end
end
