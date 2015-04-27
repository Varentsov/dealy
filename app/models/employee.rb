class Employee < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :employee_tasks
  has_many :tasks, through: :employee_tasks
  has_many :proposals


  def user_name
    user.name if user.present?
  end
end
