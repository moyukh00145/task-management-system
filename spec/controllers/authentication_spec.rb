# rubocop:disable all

require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do

  let(:user) { FactoryBot.create(:user,:Admin) }
  
  describe 'GET #login' do
    it 'redirects to root_path if user is already logged in' do

      allow(controller).to receive(:session).and_return(user_id: user.id)

      get :login

      expect(response).to redirect_to(root_path)
    end

    it 'renders the login template if user is not logged in' do
      get :login

      expect(response).to render_template(:login)
    end
  end

  

  describe 'GET #logout' do
    it 'revokes Google OAuth token and resets session' do
      allow(HTTParty).to receive(:get)

      get :logout

      expect(HTTParty).to have_received(:get).with(/https:\/\/accounts\.google\.com\/o\/oauth2\/revoke\?token=/)
      expect(session).to be_empty
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #add_admin_user' do
    it 'redirects to root_path if user is already logged in' do
      allow(controller).to receive(:session).and_return(user_id: user.id)

      get :add_admin_user

      expect(response).to redirect_to(root_path)
    end

    it 'renders the add_admin_user template if user is not logged in' do
      get :add_admin_user

      expect(response).to render_template(:add_admin_user)
    end
  end

  describe 'POST #add_user' do
    let(:user_params) { {fname: 'admin', lname: 'singh', email: 'adminsing@example.com'}}

    it 'checks and creates an admin user' do
      allow(controller).to receive(:people_params).and_return(user_params)
      allow(controller).to receive(:check_and_create_admin_user).and_return(true)

      post :add_user, format: :json

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(json_response["status"]).to be_falsey
    end
  end
end
# rubocop:enable all
