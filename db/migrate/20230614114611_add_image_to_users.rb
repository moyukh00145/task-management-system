# frozen_string_literal: true

# This is database migration
class AddImageToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :image, :string
  end
end
