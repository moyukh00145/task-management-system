# frozen_string_literal: true

# This is database migration
class AddSurnameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :surname, :string
  end
end
