class Employee < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :employee_tasks, dependent: :destroy
  has_many :tasks, through: :employee_tasks
  has_many :inbox_proposals, class_name: Proposal, foreign_key: :receiver_id
  has_many :outbox_proposals, class_name: Proposal, foreign_key: :supplier_id
  has_many :employee_roles, dependent: :destroy
  has_many :roles, through: :employee_roles

  after_create :add_roles_to_first_user

  scope :users, -> { where(is_group: false) }
  scope :groups, -> { where(is_group: true) }


  def user_name
    user.name if user.present?
  end

  def in_control_tasks
    tasks.merge(EmployeeTask.in_control)
  end

  def active_tasks
    tasks.merge(EmployeeTask.in_active)
  end

  def active_tasks_with_finished
    tasks.merge(EmployeeTask.active_and_finished_tasks)
  end

  private

    def add_roles_to_first_user
      if group.employees.users.count == 1
        employee = group.employees.users.first
        admin_role = group.roles.first
        acceptor_role = group.roles.second
        EmployeeRole.create!(employee_id: employee.id, role_id: admin_role.id)
        EmployeeRole.create!(employee_id: employee.id, role_id: acceptor_role.id)
      end
    end

    def delete_employee_tasks
      EmployeeTask.where(employee_id: id).map(&:destroy!)
    end
end
