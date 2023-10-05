# frozen_string_literal: true

# DashboardController class
class DashboardController < ApplicationController
  include ApplicationHelper
  include DashboardHelper

  before_action :current_user
  before_action :check_session, except: [:index]
  before_action :notifications, :all_notifications_type, except: [:index]

  def index
    redirect_to authentication_login_path unless session[:user_id].present?
    return unless session[:user_id].present?

    @user = User.find_by(employee_id: session[:user_id])
    redirect_to dashboard_mytask_path
  end

  def mytask
    @active_window = 'mytask'
    @assigned_mytasks = assigned_tasks
    @working_mytasks = working_tasks
    @completed_mytasks = completed_tasks
  end

  def assigntask
    @active_window = 'assigntask'
    @task_category = TaskCategory.all
    @all_users ||= User.all
    @all_assigned_tasks = Task.all_assigned_tasks(current_user.employee_id, params[:page])
  end

  def adminpanel
    @active_window = 'adminpanel'
    @total_user = User.count
    @all_verified_task = Task.approaved_tasks
    @all_users = User.page_wise_user(params[:page])
    @all_task_categories = TaskCategory.all
    @all_users_with_roles = User.all
  end

  def hrpanel
    @active_window = 'hrpanel'
    @all_sended_task = Task.snded_to_hr
  end

  def mark_all_read
    notifications.each do |item|
      item.read_status = true
      item.save
    end

    respond_to do |format|
      format.js { render locals: { notification: @notifications } }
    end
  end
end
