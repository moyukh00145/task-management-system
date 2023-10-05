# frozen_string_literal: true

# This is database migration
class RemoveTaskCategoryColumnFromTask < ActiveRecord::Migration[6.1]
  def change
    remove_column :tasks, :task_category, :integer
  end
end