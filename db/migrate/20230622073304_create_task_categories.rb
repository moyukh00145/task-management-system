# frozen_string_literal: true

# This is database migration
class CreateTaskCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :task_categories do |t|
      t.string :task_name

      t.timestamps
    end
  end
end
