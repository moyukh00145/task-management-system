# frozen_string_literal: true

# This is database migration
class ChangeForeignKeyConstraints < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :sub_tasks, :tasks
    add_foreign_key :sub_tasks, :tasks, on_delete: :cascade
  end
end
