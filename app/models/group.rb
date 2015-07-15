class Group < ActiveRecord::Base
  belongs_to :account, foreign_key: :account_id, class_name: User
  has_many :employees, dependent: :destroy
  has_many :users, through: :employees
  has_ancestry
  after_create :create_employee_for_new_user, if: lambda { |group| group.account_id.present? }
  before_create :add_account_state, if: lambda { |group| group.account_id.present? }
  #after_destroy :delete_employees


  validates_presence_of :name

  enum account_state: { default: 0, user: 1 }

  scope :public_groups, -> { default }

  def name
    if self.user?
      'Личное пространство'
    else
      super
    end
  end


  private

    def delete_employees
      Employee.where(group_id: id).map(&:destroy!)
    end

    def create_employee_for_new_user
      Employee.create!(:group_id => id, :user_id => account_id)
    end

    def add_account_state
      self.account_state = Group.account_states[:user]
    end
end
