# frozen_string_literal: true

# AuthenticationController class
module AuthenticationHelper
  ADMIN_PASSWORD = 'tasksuperadmin@123'

  def find_or_create_user
    @user = User.find_by_email(@user_info.info.email)
    if @user
      @user.update_columns(employee_id: @user_info.uid)
    else
      flash[:danger] = 'You are not authorized to login'
    end
    post_user_creation
  end

  def post_user_creation
    if @user
      handle_successful_login
      WelcomeMailer.with(to: @user.email, user: @user).welcome.deliver_later
      true
    else
      handle_failed_login
      false
    end
  end

  def handle_successful_login
    flash[:success] = 'Welcome User'
    session[:user_id] = @user.employee_id
    session[:role] = @user.roles_for_database
    session[:access_token] = @user_info.credentials.token
  end

  def check_and_create_admin_user(people_params)
    if people_params[:password] == ADMIN_PASSWORD
      @user = User.create(name: people_params[:fname], surname: people_params[:lname],
                          email: people_params[:email], roles: 2)
      true
    else
      false
    end
  end

  def handle_failed_login
    render 'login'
  end
end
