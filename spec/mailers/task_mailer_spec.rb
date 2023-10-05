# rubocop:disable all
# spec/mailers/task_mailer_spec.rb

require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  let(:task) { FactoryBot.create(:task) }
  let(:user) { FactoryBot.create(:user,:Employee) }

  describe '#create' do
    let(:mail) { TaskMailer.with(to: 'recipient@example.com', task: task, assign_user: user, redirect: 'dashboard_mytask_path').create }

    it 'renders the headers' do
      expect(mail.subject).to eq('Assignment of Task')
      expect(mail.to).to eq(['recipient@example.com'])
      expect(mail.from).to eq(['collegevibes.epizy@gmail.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include("Task has been assigned to you")
      expect(mail.body.encoded).to include(task.task_name)
    end
  end

  describe '#approval_task' do
    let(:mail) { TaskMailer.with(to: 'recipient@example.com', task: task, current_user: user).approval_task }

    it 'renders the headers' do
      expect(mail.subject).to eq('Approval of Task')
      expect(mail.to).to eq(['recipient@example.com'])
      expect(mail.from).to eq(['collegevibes.epizy@gmail.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('Below Task is approved')
      expect(mail.body.encoded).to include(task.task_name) 
    end
  end

  describe '#send_to_hr' do
    let(:mail) { TaskMailer.with(to: 'hr@example.com', task: task).send_to_hr }

    it 'renders the headers' do
      expect(mail.subject).to eq('After Approval of Task download the Task file')
      expect(mail.to).to eq(['hr@example.com'])
      expect(mail.from).to eq(['collegevibes.epizy@gmail.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('Below Task is Approved and Forwarded by Admin to HR Department')
      expect(mail.body.encoded).to include(task.task_name) 
    end
  end
end
# rubocop:enable all
