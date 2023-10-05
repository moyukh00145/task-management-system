# frozen_string_literal: true

# TasksController class
class TasksController < ApplicationController
  before_action :check_session, :current_user, :notifications, :all_notifications_type
  helper_method :change_task_status
  include ApplicationHelper
  include TasksHelper

  def create
    @task_user = User.find(task_params[:assign_to].to_i)
    date_time = parse_date_time(task_params[:task_date], task_params[:task_time])
    @task = create_task(date_time)
    post_task_creation_work
    respond_to { |format| format.js { render locals: { task: @task } } }
  end

  def show
    task_show_highlighter
    @task = Task.find_authorized_task(params[:id], session[:user_id])[0]
    @sub_tasks = @task&.sub_tasks
    return if @task.present?

    render file: Rails.public_path.join('401.html'), status: :unauthorized
    nil
  end

  def edit
    @active_window = 'assigntask'
    @task = Task.find(params[:id])
    return unless @task.assign_by != session[:user_id]

    render file: Rails.public_path.join('401.html'), status: :unauthorized
    nil
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to dashboard_assigntask_path
  end

  def update
    task = Task.find(params[:id])
    task.update(update_params)
    redirect_to dashboard_assigntask_path
  end

  def add_attachments
    task = Task.find(params[:id])
    task.attachments.attach(params[:task][:attachments])
    redirect_to edit_task_path(task)
  end

  def search
    make_search_params
    @records = Task.search_tasks(@query, @status, current_user.id)
    respond_to { |format| format.js { render locals: { records: @records, status: params[:search][:status] } } }
  end

  def change_task_status
    fn_st = update_task_status
    respond_to do |format|
      format.js { render locals: { final_status: fn_st[:status], task: fn_st[:tasks][0] } }
    end
  end

  def change_subtask_status
    sub_task = SubTask.update_subtask_params(sub_tasks_params[:id].to_i,
                                             { status: sub_tasks_params[:status].to_i })
    final_status = task_status_changed(sub_task[0].task_id)
    respond_to { |format| format.js { render locals: { final_status:, task: @task, sub_task: sub_task[0] } } }
  end

  def apply_filters
    identify = params[:filters][:identify]
    @mytasks = Task.filter_user(@user.id).filter_status(identify)
                   .filter_day(calculate_day).filter_priority(priority_generator)
    respond_to { |format| format.js { render locals: { identification: identify, task: @mytasks } } }
  end

  def approve
    @task = Task.find(params[:id].to_i)
    approave_task
    respond_to { |format| format.js { render locals: { task: @task } } }
  end

  private

  def task_params
    params.require(:task_data).permit(:task_name, :task_category, :task_date, :task_des, :task_time, :task_attachments,
                                      :notification_interval, :assign_to, :task_importance, sub_task: {})
  end

  def update_params
    params.require(:task).permit(:task_date, :task_time, :attachments)
  end

  def sub_tasks_params
    params.require(:subtask_data).permit(:id, :status, :attachments)
  end
end
