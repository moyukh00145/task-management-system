# frozen_string_literal: true

# This is database migration
class AddConstraintsToColumn < ActiveRecord::Migration[6.1]
  def change
    change_column_null :notifications, :message, false
    change_column_default :notifications, :read_status, from: nil, to: false
    change_column_null :sub_tasks, :name, false
    change_column_default :sub_tasks, :status, from: nil, to: 0
    change_column_null :task_categories, :task_name, false
    change_column_null :tasks, :task_name, false
  end
end
