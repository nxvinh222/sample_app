class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".can_not_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.reset_digest_after_update
      flash[:success] = t ".pass_reset_ok"
      redirect_to @user
    else
      flash[:danger] = t ".reset_failed"
      render :edit
    end
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".reset_password_email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not_found"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMITTED_PASSWORD_FIELDS
  end

  def get_user
    @user = User.find params[:email]
    # exception caught in application controller
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".password_reset_expired"
    redirect_to new_password_reset_url
  end
end
