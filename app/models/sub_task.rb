# frozen_string_literal: true

# Subtask Model
class SubTask < ApplicationRecord
  belongs_to :task
  after_create :create_sub_uid

  scope :pending_subtask_count, ->(task_id) { where(task_id:).where(status: [0, 1]).count }
  scope :update_subtask_params, ->(id, update_params) { where(id:).update(update_params) }

  after_update :update_task_of_subtask

  def create_sub_uid
    self.uid = format('SubTask_%<taskuid>s%<sub_task_id>04d', taskuid: task.uid[5..], sub_task_id: id)
    save
  end

  def update_task_of_subtask
    return unless saved_changes.keys.include?('status') && saved_changes.values[0][1] == 'Working'

    Task.update_task_params(task_id, { status: 1 }) unless Task.find(task_id).Working?
  end
end
