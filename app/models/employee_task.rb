class EmployeeTask < ActiveRecord::Base
  enum state: [:active, :delegated, :prepare_to_delegate]
  enum role: {author: 0, performer: 1, auditor: 2}
  belongs_to :task
  belongs_to :employee

  scope :in_control, -> { where.not(state: 0) }
  scope :in_active, -> { where(state: 0) }

  def str_status
    case state
      when 'active'
        "Активно"
      when 'delegated'
        "Делегировано"
      when 'prepare_to_delegate'
        "Ожидание решения"
      else
        "Ошибка"
    end
  end
end
