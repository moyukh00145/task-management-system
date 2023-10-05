# frozen_string_literal: true

# This is database migration
class CreateSubTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_tasks do |t|
      t.string :name
      t.integer :status
      t.text :description
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
