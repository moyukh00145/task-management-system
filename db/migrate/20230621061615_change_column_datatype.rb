# frozen_string_literal: true

# This is database migration
class ChangeColumnDatatype < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :employee_id, :string
  end
end
