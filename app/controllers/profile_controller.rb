# frozen_string_literal: true

# ProfileController class
class ProfileController < ApplicationController
  before_action :check_session, :current_user, :notifications, :all_notifications_type
  def index; end

  def update
    @user = User.find_by(employee_id: session[:user_id])
    @user.image = params[:user][:image]
    @user.save(validate: false)
    redirect_to profile_index_path
  end
end
