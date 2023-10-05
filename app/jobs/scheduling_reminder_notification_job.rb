# frozen_string_literal: true

# SchedulingReminderNotificationJob class
class SchedulingReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform
    tasks = Task.all.where.not(status: 2).where(next_notification_date: Date.today)
    tasks.each do |task|
      send_reminder(task.user.employee_id, "Your task with task name: #{task.task_name} is still pending")
    end
  end
end
