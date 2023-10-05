# frozen_string_literal: true

# This is database migration
class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.text :message
      t.boolean :read_status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
