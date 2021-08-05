class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated
        create_session_with_remember_option user
        return
      end
      flash[:warning] = t ".account_not_activated"
      redirect_to root_url
      return
    end
    flash.now[:danger] = t "sessions.new.invalid_email_password_combination"
    render :new
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def create_session_with_remember_option user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end
end
