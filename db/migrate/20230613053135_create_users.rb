# frozen_string_literal: true

# This is database migration
class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :employee_id

      t.timestamps
    end
  end
end
