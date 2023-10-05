# rubocop:disable all
# spec/controllers/tasks_controller_spec.rb

require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  let(:user) { FactoryBot.create(:user,:Admin) }
  let(:user2) { FactoryBot.create(:user,:Employee) }
  let(:category) {FactoryBot.create(:task_category, task_name: 'Demo')}
  describe 'POST #create' do
    before do
      session[:user_id]= user.employee_id
      
    end
    let(:valid_params) do
    {
      task_data: {
        task_name: 'Sample Task',
        task_category: category.id,
        sub_task: {},
        task_date: "2023-09-30",
        task_time: "13:24",
        assign_to: user2.id,
        task_importance: 2,
        notification_interval: 2,
        task_des: 'Sample description'
      }
    }
    end
    context 'with valid parameters' do
      it 'creates a new task' do
        expect { post :create, params: valid_params, format: :js }.to change(Task, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new task' do
        invalid_params = valid_params
        invalid_params[:task_data][:task_category] = nil 

        expect do
          post :create, params: invalid_params
        end.not_to change(Task, :count)
      end
    end
  end

  describe 'GET #show' do
    before do
      session[:user_id]= user.employee_id  
    end
    let(:task) { FactoryBot.create(:task,user_id: user.id) } 

    context 'with an authorized task' do
      it 'renders the show template' do
        get :show, params: { id: task.id }
        expect(response).to render_template(:show)
      end
    end

    context 'with an unauthorized task' do
      it 'returns unauthorized status' do
        allow(Task).to receive(:find_authorized_task).and_return([])
        get :show, params: { id: task.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #edit' do

    before do
      session[:user_id]= user.employee_id  
    end
   
    let(:task) { FactoryBot.create(:task, assign_by: user.employee_id) }
    it 'renders the edit template' do
      get :edit, params: { id: task.id }
      expect(response).to render_template(:edit)
    end

    it 'returns a 401 unauthorized status for tasks not assigned by the current user' do
      task.update(assign_by: user2.id)
      get :edit, params: { id: task.id }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH #update' do
    before do
      session[:user_id]= user.employee_id  
    end

    let(:task) { FactoryBot.create(:task,user_id: user.id) }
    let(:update_params) { { task_date: '2023-09-12', task_time: '14:30' } }
    it 'updates the task' do
      patch :update, params: { id: task.id, task: update_params }
      expect(task.reload.task_date.strftime('%Y-%m-%d %H:%M')== '2023-09-12 14:30')
    end

    it 'redirects to dashboard after updating' do
      patch :update, params: { id: task.id, task: update_params }
      expect(response).to redirect_to(dashboard_assigntask_path)
    end
  end

  describe 'DELETE #destroy' do
    before do
      session[:user_id]= user.employee_id  
    end

    let(:task) { FactoryBot.create(:task,user_id: user.id) }
    it 'destroys the task' do
      delete :destroy, params: { id: task.id }
      expect(Task.exists?(task.id)).to be_falsey
    end

    it 'redirects to dashboard after destroying' do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(dashboard_assigntask_path)
    end
  end

  describe 'GET #search' do
    before do
      session[:user_id]= user.employee_id  
    end
    let(:task) { FactoryBot.create(:task,task_name:'Demo',user_id: user.id) }
    it 'renders the search template' do
      get :search, params: { search: { query:task.task_name ,status: 'pending' } }, format: :js, xhr: true
      expect(response).to render_template(:search)
    end

    it 'assigns records and status' do
      get :search, params: { search: { query:'Dem' ,status: 0} }, format: :js, xhr: true
      records = controller.instance_variable_get(:@records)
      status = controller.instance_variable_get(:@status)
      expect(records).to be_a(Elasticsearch::Model::Response::Records)
      expect(status).to eq(task.status_for_database)
    end
  end

  describe 'PATCH #change_task_status' do
    before do
      session[:user_id]= user.employee_id  
    end
    let(:task) { FactoryBot.create(:task,task_name:'Demo',user_id: user.id) }
    it 'changes the task status' do
      patch :change_task_status, params: { task_data: {id: task.id, status: 1 } }, format: :js
      expect(task.reload.status).to eq('Working')
    end

    it 'renders the change_task_status.js.erb template' do
      patch :change_task_status, params: { task_data: {id: task.id, status: 1 }}, format: :js
      expect(response).to render_template('tasks/change_task_status')
    end
  end

  describe 'PATCH #change_subtask_status' do
    before do
      session[:user_id]= user.employee_id  
    end
    let(:task) { FactoryBot.create(:task,task_name:'Demo',user_id: user.id) }
    let(:sub_task) { FactoryBot.create(:sub_task, task: task) }

    it 'changes the subtask status' do
      patch :change_subtask_status, params: { subtask_data: { id: sub_task.id, status: 1 } }, format: :js
      expect(sub_task.reload.status).to eq('Working')
    end

    it 'renders the change_subtask_status.js.erb template' do
      patch :change_subtask_status, params: { subtask_data: { id: sub_task.id, status: 1 } }, format: :js
      expect(response).to render_template('tasks/change_subtask_status')
    end
  end

  describe 'GET #apply_filters' do

    before do
      session[:user_id]= user.employee_id  
    end
    let(:task) { FactoryBot.create(:task,task_name:'Demo',user_id: user.id, task_date: Date.tomorrow, status: 0, task_importance: 0) }

    it 'renders the apply_filters template' do
      get :apply_filters, params: { filters: { identify: 'assigned', day: 0, priority: 0 } }, format: :js, xhr: true
      expect(response).to render_template(:apply_filters)
    end

    it 'find the task with filter items' do
      get :apply_filters, params: { filters: { identify: 'assigned', day: 0, priority: 0 } }, format: :js, xhr: true
      task.reload
      mytasks = controller.instance_variable_get(:@mytasks)
      expect(mytasks.count).to be > 0
    end
  end

  describe 'GET #approve' do
    before do
      session[:user_id]= user.employee_id  
    end
    let(:task) { FactoryBot.create(:task,task_name:'Demo',user_id: user.id, task_date: Date.tomorrow, status: 0, task_importance: 0) }
    let(:task2) { FactoryBot.create(:task,task_name:'Demo',user_id: user.id, task_date: Date.yesterday, status: 2, task_importance: 0) }
    it 'Not approave those task wich is not complete' do
      get :approve, params: { id: task.id }, format: :js, xhr: true
      expect(task.reload.task_approval).to be_falsey
    end

    it 'approves the task which is completed' do
      get :approve, params: { id: task2.id }, format: :js, xhr: true
      expect(task2.reload.task_approval).to be_truthy
    end

    it 'renders the approve.js.erb template' do
      get :approve, params: { id: task.id }, format: :js, xhr: true
      expect(response).to render_template('tasks/approve')
    end
  end
end
# rubocop:enable all
