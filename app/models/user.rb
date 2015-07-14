class User < ActiveRecord::Base
  has_secure_password
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  after_create :create_group
  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, on: :update, unless: lambda { |user| user.password.blank? }
  has_many :recipients, dependent: :destroy
  has_many :messages, through: :recipients
  has_many :conversations, through: :recipients
  has_many :employees
  has_many :groups, through: :employees
  has_many :workspaces
  has_many :my_groups, foreign_key: :account_id, class_name: 'Group'

  before_update :update_my_group_name

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def name
    last_name + ' ' + first_name
  end

  def update_my_group_name
    if self.last_name_changed? or self.first_name_changed?
      Group.find_by_account_id(self.id).update_attribute(:name, self.name)
    end
  end

  private

    def create_group
      group = Group.create!(:name => self.name, :account_id => self.id)
    end

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
