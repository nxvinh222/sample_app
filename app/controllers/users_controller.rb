class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(show create new)
  before_action :correct_user, only: %i(edit update)
  before_action :admin?, only: :destroy

  def index
    @users = User.page params[:page]
  end

  def show
    @microposts = @user.microposts.page params[:page]
  end

  def edit; end

  def new
    @user = User.new
  end

  def update
    if @user.update user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      flash[:danger] = t ".profile_update_failed"
      render :edit
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:success] = t ".please_check_email"
      redirect_to @user
    else
      flash[:danger] = t ".registration_failed"
      render :new
    end
  end

  def destroy
    if current_user != @user && @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".delete_failed"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::PERMITTED_FIELDS
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin?
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find params[:id]
    # exception handled in application controller
  end
end
