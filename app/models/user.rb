class User < ActiveRecord::Base
  has_secure_password
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, on: :update, unless: lambda { |user| user.password.blank? }
  has_many :recipients, dependent: :destroy
  has_many :messages, through: :recipients
  has_many :conversations, through: :recipients

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def name
    last_name + ' ' + first_name
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
