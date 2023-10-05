# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    task_name { 'Sample Task' }
    task_category { association :task_category }
    task_date { Time.zone.today }
    task_time { Time.zone.now }
    repeat_interval { 1 }
    task_importance { Task.task_importances.keys.sample }
    description { 'Sample task description' }
    user { association(:user, roles: 0) }
    trait :with_sub_tasks do
      after(:create) do |task|
        create_list(:sub_task, 3, task:)
      end
    end
  end
end
