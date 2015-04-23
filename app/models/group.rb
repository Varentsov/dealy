class Group < ActiveRecord::Base
  belongs_to :account, foreign_key: :account_id, class_name: User
  belongs_to :root_group, foreign_key: :root_id, class_name: Group
  belongs_to :parent_group, foreign_key: :parent_id, class_name: Group
  has_many :employees
  has_many :users, through: :employees
  has_ancestry
  after_create :create_employee_for_new_user, if: lambda { |group| group.account_id.present? }


  validates_presence_of :name
  validate :parent_group_presence


  private

    def create_employee_for_new_user
      Employee.create!(:group_id => id, :user_id => account_id)
    end

    def parent_group_presence
      if root_id.present?
        validates_presence_of :parent_id
      end
    end
end
