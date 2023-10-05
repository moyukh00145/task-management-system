# frozen_string_literal: true

# ApplicationHelper class
module ApplicationHelper
  def send_notification(id, msg)
    user = User.find_by(employee_id: id)
    user.notification.create(sender_id: current_user.id, message: msg, read_status: false, notification_type: 0)
    user.save
    ActionCable.server.broadcast("notification_for_#{id}", { message: msg, path: dashboard_mytask_path.to_s })
  end

  def task_show_highlighter
    @active_window = (params[:k] == '1' ? 'assigntask' : 'mytask')
  end
end
