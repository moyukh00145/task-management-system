# frozen_string_literal: true

# TaskCategory Model
class TaskCategory < ApplicationRecord
  validates :task_name, presence: true, on: :create
  has_many :tasks, dependent: :destroy

  default_scope { order(:task_name) }

  scope :update_category, ->(params) { where(id: params[:id]).update(task_name: params[:task_name]) }
end
