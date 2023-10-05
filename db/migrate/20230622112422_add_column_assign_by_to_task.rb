# frozen_string_literal: true

# This is database migration
class AddColumnAssignByToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :assign_by, :string
  end
end
