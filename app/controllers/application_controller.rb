class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :logged_user

  include SessionsHelper

  private

    def logged_user
      if current_user.nil?
        redirect_to sign_in_path, notice: 'You should sign in or sign up'
      end
    end

    def redirect_to_back_or_default(*args)
      if request.env['HTTP_REFERER'].present? && request.env['HTTP_REFERER'] != request.env['REQUEST_URI']
        redirect_to :back, *args
      else
        redirect_to root_url, *args
      end
    end
end
