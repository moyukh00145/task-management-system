# rubocop:disable all

require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { FactoryBot.create(:user,:Admin) }
  let(:notification) {FactoryBot.create(:notification, user: user)}

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:check_session)
    allow(controller).to receive(:notifications).and_return([notification])
    allow(controller).to receive(:all_notifications_type)
  end

  describe 'GET #index' do
    it 'redirects to login if user is not present in the session' do
      get :index
      expect(response).to redirect_to(authentication_login_path)
    end

    it 'redirects to mytask if user is present in the session' do
      session[:user_id] = user.employee_id
      get :index
      expect(response).to redirect_to(dashboard_mytask_path)
    end
  end

  describe 'GET #mytask' do
    it 'renders the mytask template' do
      get :mytask
      expect(response).to render_template(:mytask)
    end
  end

  describe 'GET #assigntask' do
    it 'renders the assigntask template' do
      get :assigntask
      expect(response).to render_template(:assigntask)
    end
  end

  describe 'GET #adminpanel' do
    it 'renders the adminpanel template' do
      get :adminpanel
      expect(response).to render_template(:adminpanel)
    end
  end

  describe 'GET #hrpanel' do
    it 'renders the hrpanel template' do
      get :hrpanel
      expect(response).to render_template(:hrpanel)
    end
  end

  describe 'POST #mark_all_read' do
    it 'marks all notifications as read' do
      allow(controller).to receive(:notifications).and_return([notification])

      post :mark_all_read, format: :js

      expect(notification.reload.read_status).to be(true)
    end

    it 'renders the mark_all_read.js.erb template' do
      post :mark_all_read, format: :js
      expect(response).to render_template('dashboard/mark_all_read')
    end
  end
end


# rubocop:enable all