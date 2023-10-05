# frozen_string_literal: true

# This is database migration
class ChnageForeignKeyConstraintToNotification < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :notifications, :users
    add_foreign_key :notifications, :users, on_delete: :cascade
  end
end
