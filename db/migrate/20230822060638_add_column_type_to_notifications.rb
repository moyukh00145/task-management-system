# frozen_string_literal: true

# This is database migration
class AddColumnTypeToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :notification_type, :integer, default: 0
  end
end
