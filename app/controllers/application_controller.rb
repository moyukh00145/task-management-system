# frozen_string_literal: true

# ApplicationController class
# rubocop:disable all
class ApplicationController < ActionController::Base
  @@welcome_flash = false
  @active_window = 'home'
  helper_method :current_user
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::RoutingError, with: :render_not_found

  def current_user
    @user ||= User.find_by(employee_id: session[:user_id])
  end

  def check_session
    return unless session[:user_id].nil?

    redirect_to root_path
  end

  def notifications
    unless current_user.present?
      session[:user_id]=nil
      redirect_to root_path
      return
    end
    @notifications ||= current_user.notification.all.where(read_status: false)
  end

  def all_task_status
    @task_status = {
      'assigned' => 0,
      'working' => 1,
      'completed' => 2
    }
  end

  def all_notifications_type
    @notifications_types = {
      0 => dashboard_mytask_path,
      1 => dashboard_adminpanel_path,
      2 => dashboard_hrpanel_path
    }
  end

  def render_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found
  end

  def not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
# rubocop:enable all