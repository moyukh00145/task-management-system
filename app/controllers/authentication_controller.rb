# frozen_string_literal: true

require 'httparty'
# AuthenticationController class
class AuthenticationController < ApplicationController
  include AuthenticationHelper
  skip_before_action :verify_authenticity_token, only: %i[logout login create]

  def login
    redirect_to root_path if session[:user_id]
  end

  def create
    @user_info = request.env['omniauth.auth']
    status = find_or_create_user
    redirect_to root_path if status == true
  end

  def logout
    HTTParty.get("https://accounts.google.com/o/oauth2/revoke?token=#{session[:access_token]}")
    reset_session
    redirect_to root_path
  end

  def add_admin_user
    return unless session[:user_id]

    redirect_to root_path
  end

  def add_user
    response = check_and_create_admin_user(people_params)
    respond_to { |format| format.json { render json: { status: @user.present?, match: response } } }
  end

  private

  def people_params
    params.require(:info).permit(:fname, :lname, :email, :password)
  end
end
