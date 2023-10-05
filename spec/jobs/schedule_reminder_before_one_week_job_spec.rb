# rubocop:disable all

require 'rails_helper'

RSpec.describe ScheduleReminderBeforeOneWeekJob, type: :job do
  describe '#perform' do
    let(:user) { FactoryBot.create(:user,:Employee) } 

    it 'sends reminders for tasks due in one week' do
      task_due_in_one_week = FactoryBot.create(:task, user: user, task_date: Date.today - 7.days, status: 1)

      expect { described_class.perform_now }.to change(Notification, :count).by(1)
    end

    it 'does not send reminders for tasks not due in one week' do
      task_not_due_in_one_week = FactoryBot.create(:task, user: user, task_date: Date.today + 10.days)

      expect { described_class.perform_now }.not_to change(Notification, :count)
    end
  end
end


# rubocop:enable all
