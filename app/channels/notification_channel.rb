# frozen_string_literal: true

# NotificationChannel class
class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_for_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
