# rubocop:disable all

require 'rails_helper'

RSpec.describe ProfileController, type: :controller do
  let(:user) { FactoryBot.create(:user,:Employee) } 

  before do
    allow(controller).to receive(:check_session)
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:notifications)
    allow(controller).to receive(:all_notifications_type)
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe 'PATCH #update' do

    before do
      session[:user_id] = user.employee_id
    end

    let(:image_path) { Rails.root.join('spec', 'fixtures', 'files', 'pro.jpg') }
    let(:image_file) { fixture_file_upload(image_path, 'image/jpg') }

    it 'updates the user image' do
      patch :update, params: { id: user.id ,user: { image: image_file } }

      expect(response).to redirect_to(profile_index_path)
      expect(user.reload.image).to be_attached 
    end
  end
end


# rubocop:enable all