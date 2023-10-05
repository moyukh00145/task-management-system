# frozen_string_literal: true

# This is database migration
class AddColumnStatusToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :status, :integer
  end
end
