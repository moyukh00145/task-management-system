# rubocop:disable all

# spec/helpers/authentication_helper_spec.rb

require 'rails_helper'

RSpec.describe AuthenticationHelper, type: :helper do
  let(:user_info) { OpenStruct.new(info: OpenStruct.new(email: 'test@example.com', uid: '123'), credentials: OpenStruct.new(token: 'some_token')) }

  describe '#find_or_create_user' do
    it 'finds and updates an existing user' do
      existing_user = FactoryBot.create(:user,:Employee, email: 'test@example.com')
      allow(helper).to receive(:post_user_creation)

      helper.instance_variable_set(:@user_info, user_info)
      expect(existing_user.reload.employee_id == '123')
      helper.find_or_create_user

      expect(helper).to have_received(:post_user_creation)
    end

    it 'handles failed login for a non-existing user' do
      allow(helper).to receive(:handle_failed_login)

      helper.instance_variable_set(:@user_info, user_info)
      helper.find_or_create_user

      expect(helper).to have_received(:handle_failed_login)
    end
  end

  describe '#check_and_create_admin_user' do
    it 'creates an admin user with correct password' do
      allow(helper).to receive(:render)

      people_params = { fname: 'John', lname: 'Doe', email: 'admin@example.com', password: AuthenticationHelper::ADMIN_PASSWORD }
      expect(User).to receive(:create).with(name: 'John', surname: 'Doe', email: 'admin@example.com', roles: 2)
      expect(helper.check_and_create_admin_user(people_params)).to be_truthy

      expect(helper).not_to have_received(:render)
    end

    it 'does not create an admin user with incorrect password' do
      people_params = { fname: 'John', lname: 'Doe', email: 'admin@example.com', password: 'incorrect_password' }
      expect(User).not_to receive(:create)
      expect(helper.check_and_create_admin_user(people_params)).to be_falsey
    end
  end

  describe '#post_user_creation' do
    it 'handles successful login and redirects on user creation' do
      helper.instance_variable_set(:@user_info, user_info)
      user = FactoryBot.create(:user, :Employee, email: 'test@example.com')
      helper.instance_variable_set(:@user, user)
      expect(helper.post_user_creation).to be_truthy
    end

    it 'handles failed login on user creation' do
      allow(helper).to receive(:handle_failed_login)
      allow(helper).to receive(:render)

      helper.instance_variable_set(:@user, nil)
      helper.post_user_creation

      expect(helper).to have_received(:handle_failed_login)
      expect(helper).not_to have_received(:render)
    end
  end

  describe '#handle_successful_login' do
    it 'sets flash, session, and credentials on successful login' do
      allow(controller).to receive(:flash).and_return({})
      allow(controller).to receive(:session).and_return({})
      user = FactoryBot.create(:user,:Employee, email: 'test@example.com')
      helper.instance_variable_set(:@user, user)
      helper.instance_variable_set(:@user_info, user_info)
      helper.handle_successful_login

      expect(controller.flash[:success]).to eq('Welcome User')
      expect(controller.session[:user_id]).to eq(user.employee_id)
      expect(controller.session[:role]).to eq(user.roles_for_database)
      expect(controller.session[:access_token]).to eq('some_token')
    end
  end
end



#rubocop:enable all
