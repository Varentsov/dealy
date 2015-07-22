class Role < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :group
  has_many :employee_roles, dependent: :destroy
  has_many :employees, through: :employee_roles
  validate :uniqueness_of_names_in_group



  private

    def uniqueness_of_names_in_group
      count = 0
      group.roles.each do |role|
        if role.name == name
          count += 1
        end
        if count >= 2
          errors.add(:name, 'Уже есть такая роль')
          break
        end
      end
    end
end
