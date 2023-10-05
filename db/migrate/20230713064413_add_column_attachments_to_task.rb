# frozen_string_literal: true

# This is database migration
class AddColumnAttachmentsToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :attachments, :string
  end
end
