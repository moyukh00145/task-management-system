# rubocop:disable all

# spec/controllers/admin_controller_spec.rb

require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  let(:admin_user) { FactoryBot.create(:user,:Admin) }


  before do
    allow(controller).to receive(:check_session)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'POST #add_user' do
    it 'creates a new user' do

      expect do
       post :add_user, params: { info: { fname: 'John', lname: 'Doe', email: 'john@example.com', roles: User.roles[:User] } }, format: :js
      end.to change(User, :count).by(1)
      expect(response).to render_template(:add_user)
      expect(controller.instance_variable_get(:@user)).to be_instance_of(User)
      
    end
  end

  describe 'PATCH #change_role' do
    let(:user) { FactoryBot.create(:user,:Employee) }
    it 'changes the role of a user' do
      patch :change_role, params: { id: user.id, role: 1 }, format: :js
      expect(response).to render_template(:change_role)
      expect(user.reload.roles).to eq('HRD')
    end
  end

  describe 'PATCH #send_to_hr' do
    it 'marks a task as sent to HR' do
      task = FactoryBot.create(:task)
      patch :send_to_hr, params: { id: task.id }, format: :js
      expect(response).to render_template(:send_to_hr)
      expect(task.reload.sended_to_hr).to be_truthy
    end
  end

  describe 'GET #search_user' do
    let(:user_to_be_searched) { FactoryBot.create(:user, name: 'John Doe', roles: 0)}
    it 'searches for users' do
      get :search_user, params: { query: 'Jo' }, format: :js, xhr: true
      expect(response).to render_template(:search_user)
    end
  end
end

# rubocop:enable all
