module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
    session.delete(:workspace)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(User.encrypt(cookies[:remember_token])) if cookies[:remember_token].present?
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    session.delete(:workspace)
    self.current_user = nil
  end

  def current_employee
    session[:workspace] ||= Group.where(:account_id => current_user.id).take.id
    @employee = Employee.where(:user_id => current_user.id, :group_id => session[:workspace]).take
  end

  def current_workspace
    session[:workspace] ||= Group.where(:account_id => current_user.id).take.id
    @group = Group.find(session[:workspace])
  end
end
