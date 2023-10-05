# frozen_string_literal: true

# This is database migration
class AddColumnDescriptionToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :description, :text
  end
end
