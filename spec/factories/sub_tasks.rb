# frozen_string_literal: true

FactoryBot.define do
  factory :sub_task do
    name { 'Sample SubTask' }
    status { 0 }
    description { 'Sample subtask description' }
    task { association :task }
  end
end
