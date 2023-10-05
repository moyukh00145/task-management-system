# frozen_string_literal: true

# This is database migration
class AddColumnUidToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :uid, :string
    add_column :sub_tasks, :uid, :string
  end
end
