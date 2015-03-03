class Task < ActiveRecord::Base
  enum planning_state: [:to_sometime, :to_next, :to_today]
  validates :title, presence: true


  def over_deadline?
    true if deadline < Date.today
  end
end
