# frozen_string_literal: true

#rubocop:disable all
Rails.application.routes.draw do
  root 'dashboard#index'
  get 'superuser/add/adminuser', to: 'authentication#add_admin_user'
  post 'superuser/add/adminuser', to: 'authentication#add_user'
  get 'authentication/login', to: 'authentication#login'
  get '/auth/:provider/callback', to: 'authentication#create'
  get 'authentication/logout', to: 'authentication#logout'

  resources :profile, only: %i[index update]

  # Dashboard routes
  get 'dashboard/mytask'
  get 'dashboard/assigntask'
  get 'dashboard/adminpanel'
  get 'dashboard/hrpanel'
  put 'dashboard/mark_all_read'
  scope '/dashboard/hrpanel' do
    get 'generate_pdf', to: 'pdfs#generate_pdf'
  end
  scope '/dashboard/assigntask' do
    resources :tasks
    patch 'approve_task', to: 'tasks#approve'
  end

  # Admin Panel routes
  resources :admin, only: [] do
    collection do
      post 'add_user'
      patch 'change_role'
      patch 'send_to_hr'
      get 'search_user'
      resources :task_category, only: %i[create update destroy]
    end
  end

  # Task routes
  patch 'tasks/change_task_status'
  patch 'tasks/change_subtask_status'
  get 'tasks/apply_filters'
  post 'tasks/add_attachments'
  delete 'tasks/delete_attachments'
  get 'tasks/show'
  get 'tasks/search'

  # Exceptions
  match '*unmatched', to: 'application#not_found', layout: false, via: :all, constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
end
# rubocop:enable all
