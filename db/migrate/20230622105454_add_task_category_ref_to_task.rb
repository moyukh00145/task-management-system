# frozen_string_literal: true

# This is database migration
class AddTaskCategoryRefToTask < ActiveRecord::Migration[6.1]
  def change
    add_reference :tasks, :task_category, null: false, foreign_key: true
  end

  # change_column :tasks, :user_id,:string
  # add_column :tasks, :assign_by, :string
end
