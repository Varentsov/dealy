class SessionsController < ApplicationController
  before_action :check_if_already_logged, except: :destroy
  skip_before_action :logged_user, except: :destroy

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_to user, notice: 'Successful logged in'
    else
      flash.now[:notice] = "Error in pair email/pass"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  private

    def check_if_already_logged
      if signed_in?
        redirect_to root_url, notice: 'Already logged'
      end
    end
end
