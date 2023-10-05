FactoryBot.define do
  factory :notification do
    association :user
    sender_id { FactoryBot.create(:user,:Employee).id } # Assuming you have a User model

    message { 'This is a notification message.' }
    read_status { false }
    notification_type { 0 }

    trait :read do
      read_status { true }
    end

    trait :unread do
      read_status { false }
    end
  end
end