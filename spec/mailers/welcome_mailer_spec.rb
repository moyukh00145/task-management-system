# rubocop:disable all

# spec/mailers/welcome_mailer_spec.rb

require 'rails_helper'

RSpec.describe WelcomeMailer, type: :mailer do
  describe '#welcome' do
    let(:user) { FactoryBot.create(:user,:Employee, email: 'test@example.com') }
    let(:mail) { described_class.with(user: user, to: user.email).welcome }

    it 'renders the headers' do
      expect(mail.subject).to eq('Welcome Mail')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['collegevibes.epizy@gmail.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include("Welcome #{user.name} #{user.surname} to this Task Management System")
    end
  end
end


# rubocop:enable all
