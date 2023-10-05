# frozen_string_literal: true

# TasksHelper module
module TasksHelper
  def parse_date_time(date, time)
    DateTime.parse("#{date}T#{time}")
  end

  def create_task(date_time)
    @task_user.task.create(task_name: task_params[:task_name],
                           task_category: TaskCategory.find(task_params[:task_category]),
                           assign_by: @user.employee_id, task_importance: task_params[:task_importance].to_i,
                           task_date: date_time, task_time: date_time,
                           description: task_params[:task_des],
                           repeat_interval: task_params[:notification_interval].to_i, status: 0)
  end

  def create_sub_tasks(sub_tasks_params)
    sub_tasks_params.each do |_key, value|
      @task.sub_tasks.create(name: value, status: 0)
    end
  end

  def send_notification_for_task
    msg = "Task(#id: #{@task.uid}) Has been assigned to you by #{current_user.name} #{current_user.surname}"
    send_notification(@task_user.employee_id, msg)
    redirect_url = root_url.chop + dashboard_mytask_path
    TaskMailer.with(to: @task_user.email, task: @task, assign_user: current_user,
                    redirect: redirect_url).create.deliver_later
  end

  def post_task_creation_work
    create_sub_tasks(task_params[:sub_task]) if task_params[:sub_task].present?
    if @task.repeat_interval != 0
      date = Date.today + @task.interval_of_notifications[@task.repeat_interval]
      @task.next_notification_date = date
      @task.save
    end
    send_notification_for_task
  end

  def make_search_params
    @query = params[:search][:query]
    @status = all_task_status[params[:search][:status]]
  end

  def update_task_status
    task_id = params[:task_data][:id]
    remain_count = SubTask.pending_subtask_count(task_id)
    if params[:task_data][:status].to_i == 2 && remain_count.positive?
      { status: true, tasks: [] }
    else
      { tasks: Task.update_task_params(task_id, { status: params[:task_data][:status].to_i }), status: false }
    end
  end

  def task_status_changed(task_id)
    @task = Task.find(task_id)
    @task.updated_at > (Time.now - 1.minutes)
  end

  def day_param_generator
    params[:filters][:day].present? ? params[:filters][:day].to_i : 1
  end

  def priority_generator
    params[:filters][:priority].present? ? params[:filters][:priority].to_i : 3
  end

  def calculate_day
    day_param = params[:filters][:day].present? ? params[:filters][:day].to_i : 1
    case day_param
    when 0
      Date.tomorrow
    when 1
      Date.today
    when 2
      Date.yesterday
    end
  end

  def delete_attachments
    task = Task.find(params[:task_id])
    task.attachments.find(params[:blob_id]).destroy
    redirect_to edit_task_path(task)
  end

  def approave_task
    return unless @task.status_for_database == 2

    @task.task_approval = true
    @task.save
    TaskApprovalNotificationJob.perform_later(@task, current_user, @notifications_types[1])
  end
end
