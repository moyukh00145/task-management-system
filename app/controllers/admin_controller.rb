# frozen_string_literal: true

# AdminController class
class AdminController < ApplicationController
  before_action :check_session, :current_user

  def add_user
    @user = User.create(name: people_params[:fname], surname: people_params[:lname], email: people_params[:email],
                        roles: people_params[:roles].to_i)
    @total_user = User.count
    respond_to(&:js)
  end

  def change_role
    User.user_params_update(params[:id], { roles: params[:role].to_i }) if current_user.Admin?
    respond_to(&:js)
  end

  def send_to_hr
    task = Task.update_task_params(params[:id], { sended_to_hr: true })
    TaskSendToHrDepartmentJob.perform_later(task[0], current_user, all_notifications_type[2])
    respond_to { |format| format.js { render locals: { task: } } }
  end

  def search_user
    @result = User.search_user(params[:query]).per(6)
    respond_to do |format|
      format.js { render locals: { result: @result } }
    end
  end

  private

  def people_params
    params.require(:info).permit(:fname, :lname, :email, :roles)
  end
end
