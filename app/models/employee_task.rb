class EmployeeTask < ActiveRecord::Base
  enum state: [:active, :delegated, :prepare_to_delegate, :confirmation, :completed]
  enum role: {author: 0, performer: 1, auditor: 2, reviewer: 3, group_task: 4}
  belongs_to :task
  belongs_to :employee

  scope :in_control, -> { where(state: [EmployeeTask.states[:delegated]]) }
  scope :in_active, -> { where(state: [EmployeeTask.states[:active], EmployeeTask.states[:confirmation], EmployeeTask.states[:completed]]) }

  def str_status
    case state
      when 'active'
        "Активно"
      when 'delegated'
        "Делегировано"
      when 'prepare_to_delegate'
        "Ожидание решения"
      when 'confirmation'
        "Ожидание подтверждения"
      when 'completed'
        "Завешено"
      else
        "Ошибка"
    end
  end
end
