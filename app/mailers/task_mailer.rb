# frozen_string_literal: true

# TaskMailer class
class TaskMailer < ApplicationMailer
  default from: 'collegevibes.epizy@gmail.com'
  def create
    @task = params[:task]
    @assign_user = params[:assign_user]
    @dashboard_mytask_path = params[:redirect]
    mail(to: params[:to], subject: 'Assignment of Task')
  end

  def approval_task
    @task = params[:task]
    @current_user = params[:current_user]
    mail(to: params[:to], subject: 'Approval of Task')
  end

  def send_to_hr
    @task = params[:task]
    mail(to: params[:to], subject: 'After Approval of Task download the Task file')
  end
end
