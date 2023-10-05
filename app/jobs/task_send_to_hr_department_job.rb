# frozen_string_literal: true

# TaskSendToHrDepartmentJob class
class TaskSendToHrDepartmentJob < ApplicationJob
  queue_as :default

  def perform(task, current_user, redirection_path)
    msg = "Task with task Id : #{task.uid} is Approved and Sent by Admin"
    User.all.where(roles: 1).each do |user|
      send_notification(current_user, user.employee_id, msg, redirection_path, 2)
      TaskMailer.with(to: user.email, task:).send_to_hr.deliver_later
    end
  end
end
