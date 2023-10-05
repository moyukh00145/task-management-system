# frozen_string_literal: true

# This is database migration
class AddColumnNextNotificationDateToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :next_notification_date, :datetime
    add_column :tasks, :task_approval, :boolean, default: false
    add_column :tasks, :sended_to_hr, :boolean, default: false
  end
end
