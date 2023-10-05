# rubocop:disable all

require 'rails_helper'

RSpec.describe TaskCategoryController, type: :controller do
  describe 'POST #create' do
    it 'creates a new TaskCategory' do
      post :create, params: { data: 'New Category' }, format: :js

      expect(response).to be_successful
      expect(TaskCategory.last.task_name).to eq('New Category')
    end
  end

  describe 'PATCH #update' do
    let(:task_category) { FactoryBot.create(:task_category) }

    it 'updates the TaskCategory' do
      patch :update, params: { id: task_category.id, task_name: 'Updated Category' }, format: :json

      expect(response).to be_successful
      expect(JSON.parse(response.body)['status']).to be_truthy
      expect(task_category.reload.task_name).to eq('Updated Category')
    end
  end

  describe 'DELETE #destroy' do
    let!(:task_category) { FactoryBot.create(:task_category) }

    it 'destroys the TaskCategory' do
      expect do
        delete :destroy, params: { id: task_category.id }, format: :js
      end.to change(TaskCategory, :count).by(-1)

      expect(response).to be_successful
    end
  end
end


# rubocop:enable all
