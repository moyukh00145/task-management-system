# frozen_string_literal: true

# WelcomeMailer class
class WelcomeMailer < ApplicationMailer
  default from: 'collegevibes.epizy@gmail.com'

  def welcome
    @user = params[:user]
    mail(to: params[:to], subject: 'Welcome Mail')
  end
end
