class Proposal < ActiveRecord::Base
  belongs_to :task
  belongs_to :supplier, class_name: Employee
  belongs_to :receiver, class_name: Employee
end
