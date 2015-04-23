class Employee < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :employee_tasks
  has_many :tasks, through: :employee_tasks


  def user_name
    user.name
  end
end
