# rubocop:disable all
require 'rails_helper'

RSpec.describe PdfsController, type: :controller do
  let(:user) { FactoryBot.create(:user,:HRD) } 
  let(:task) { FactoryBot.create(:task,status: 2) } 

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:check_session)
  end

  describe 'GET #generate_pdf' do
    it 'renders the PDF' do
      get :generate_pdf, params: { id: task.id }
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/pdf')
    end
  end
end

# rubocop:enable all