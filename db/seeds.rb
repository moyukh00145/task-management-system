# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.

task_categories = [
  { task_name: 'Work' },
  { task_name: 'Personal' },
  { task_name: 'Birthday Celebration' },
  { task_name: 'Cleaning' },
  { task_name: 'Meeting' },
  { task_name: 'Exam' },
  { task_name: 'Independence Day celebration' },
  { task_name: 'Payslip deliver' },
  { task_name: 'Weekend activity' },
  { task_name: 'Maintainence' }
]

TaskCategory.create!(task_categories)

User.create!(name: 'Moyukh', email: 'moyukh.sarkar@kreeti.com', roles: 2, surname: 'Sarkar')

10.times do |n|
  name = Faker::Name.first_name
  surname = Faker::Name.last_name
  email = Faker::Internet.email(name: "#{name}_#{n}")
  roles = n % 2
  User.create!(name:, surname:, email:, roles:)
end

10.times do |n|
  task_name = Faker::Lorem.sentence(word_count: 3)
  task_date = DateTime.now + n.days
  task_time = Time.parse("#{rand(8..20)}:00 AM")
  task_importance = rand(0..2)
  user_id = rand(1..10)
  task_category_id = rand(1..10)
  status = 0
  repeat_interval = rand(1..6)
  description = Faker::Lorem.paragraph(sentence_count: 3)
  Task.create!(
    task_name:,
    task_date:,
    task_time:,
    task_importance:,
    repeat_interval:,
    user_id:,
    task_category_id:,
    status:,
    description:
  )
end

10.times do |_n|
  name = Faker::Lorem.word
  status = 0
  task_id = rand(1..10)
  SubTask.create!(name:, status:, task_id:)
end
