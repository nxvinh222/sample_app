class FollowersController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @title = t ".followers"
    @users = @user.followers.page params[:page]
    render "users/show_follow"
  end
end
