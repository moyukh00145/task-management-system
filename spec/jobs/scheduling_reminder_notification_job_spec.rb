# rubocop:disable all

# spec/jobs/scheduling_reminder_notification_job_spec.rb

require 'rails_helper'

RSpec.describe SchedulingReminderNotificationJob, type: :job do
  it 'queues the job' do
    expect { described_class.perform_later }.to have_enqueued_job(described_class)
      .on_queue('default')
  end

  it 'executes perform and inform about the pending task' do
    user = FactoryBot.create(:user,:Employee)
    task = FactoryBot.create(:task, user: user, next_notification_date: Date.today, status: 1)
    expect { described_class.perform_now }.to change(Notification, :count).by(1)
  end
  it 'does not executes perform as tasks are already completed' do
    user = FactoryBot.create(:user,:Employee)
    task = FactoryBot.create(:task, user: user, next_notification_date: Date.today, status: 2)
    expect { described_class.perform_now }.not_to change(Notification, :count)
  end
end


# rubocop:enable all
