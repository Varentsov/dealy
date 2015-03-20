class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  private

    def logged_user
      if current_user.nil?
        redirect_to sign_in_path, notice: 'You should sign in or sign up'
      end
    end
end
