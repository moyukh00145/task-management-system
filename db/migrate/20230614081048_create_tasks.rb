# frozen_string_literal: true

# This is database migration
class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :task_name
      t.string :task_category
      t.datetime :task_date
      t.datetime :task_time
      t.integer :repeat_interval
      t.integer :task_importance
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
