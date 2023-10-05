# frozen_string_literal: true

# DashboardHelper module
module DashboardHelper
  def assigned_tasks
    current_user.task.where(status: 0).page(params[:page]).per(3)
  end

  def working_tasks
    current_user.task.where(status: 1).page(params[:page]).per(3)
  end

  def completed_tasks
    current_user.task.where(status: 2).page(params[:page]).per(3)
  end
end
