# rubocop:disable all

# spec/controllers/application_controller_spec.rb
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:user) { FactoryBot.create(:user,:Admin) }
  let(:notification) {FactoryBot.create(:notification, user: user,read_status: false)}

  controller do
    before_action :check_session
    def index
      render plain: 'Hello, World!'
    end
  end

  describe '#current_user' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:check_session)
    end
    it 'returns the current user' do
      expect(controller.current_user).to eq(user)
    end
  end

  describe '#check_session' do
    context 'when session[:user_id] is nil' do
      it 'redirects to root_path' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when session[:user_id] is present' do
      before { session[:user_id] = user.employee_id }

      it 'does not redirect' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#notifications' do
    context 'when user is present' do
      before do 
        session[:user_id] = user.employee_id 
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'returns user notifications' do
        expect(controller.notifications).to eq(user.notification.all.where(read_status: false))
      end
    end

    context 'when user is not present' do
      it 'redirects to root_path' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end


# rubocop:enable all