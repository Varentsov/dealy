class UsersController < ApplicationController

  def index
    @users = User.all
  end

  #aka sign_up
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to root_path, notice: 'User created' }
      else
        format.html { render :new }
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    logger.debug user_params
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Profile updated'}
      else
        format.html { render :edit }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
