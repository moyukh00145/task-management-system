# rubocop:disable all

# spec/jobs/application_job_spec.rb
require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  let(:current_user) { FactoryBot.create(:user,:Admin) }
  describe '#send_notification' do
    let(:id) { current_user.employee_id }
    let(:msg) { 'Notification message' }
    let(:notification_path) { '/notifications' }
    let(:type) { 0 }

    it 'sends a notification' do
      expect { subject.send_notification(current_user, id, msg, notification_path, type) }.to change(Notification, :count).by(1)
    end

    it 'broadcasts a message via ActionCable' do
      expect(ActionCable.server).to receive(:broadcast).with("notification_for_#{id}", { message: msg, path: notification_path })
      subject.send_notification(current_user, id, msg, notification_path, type)
    end
  end

  describe '#send_reminder' do
    let(:id) { current_user.employee_id  }
    let(:msg) { 'Reminder message' }

    it 'sends a reminder' do
      expect { subject.send_reminder(id, msg) }.to change(Notification, :count).by(1)
    end

    it 'broadcasts a message via ActionCable' do
      expect(ActionCable.server).to receive(:broadcast).with("notification_for_#{id}", { message: msg })
      subject.send_reminder(id, msg)
    end
  end
end


# rubocop:enable all
