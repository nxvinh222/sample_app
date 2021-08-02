class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".welcome_to_the_sample_app!"
      redirect_to @user
    else
      flash[:danger] = t ".registration_failed"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMITTED_FIELDS
  end
end
