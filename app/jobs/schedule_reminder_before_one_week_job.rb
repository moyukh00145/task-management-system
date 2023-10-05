# frozen_string_literal: true

# ScheduleReminderBeforeOneWeekJob class
class ScheduleReminderBeforeOneWeekJob < ApplicationJob
  queue_as :default

  def perform
    tasks = Task.all.where.not(status: 2).where(task_date: Date.today - 7.days)
    tasks.each do |task|
      send_reminder(task.user.employee_id, "You have only one week remaining to complete the task : #{task.task_name}")
    end
  end
end
