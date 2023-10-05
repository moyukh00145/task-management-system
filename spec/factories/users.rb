# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    # sequence(:email) { |n| "john.doe#{n}@example.com" }
    sequence(:email) { Faker::Internet.email }
    roles { 'Employee' }
    sequence(:employee_id) { |n| n.to_s.rjust(6, '0') }
    image { nil }
  end
end
