# rubocop:disable all

# spec/jobs/task_send_to_hr_department_job_spec.rb

require 'rails_helper'

RSpec.describe TaskSendToHrDepartmentJob, type: :job do
  let(:task) { FactoryBot.create(:task) }
  let(:current_user) { FactoryBot.create(:user,:HRD) }
  let(:redirection_path) { 'some/path' }
  it 'queues the job' do
    expect { described_class.perform_later(task, current_user, redirection_path) }
      .to have_enqueued_job(described_class)
      .on_queue('default')
  end

  it 'sending admin a notification about the task approval' do
    perform_enqueued_jobs do
      expect { described_class.perform_now(task, current_user, redirection_path) }.to change(Notification, :count).by(1)
    end
  end
  
  it 'sending approval email to the admins' do
    perform_enqueued_jobs do
      expect {
        described_class.perform_now(task, current_user, redirection_path)
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end

# rubocop:enable all
