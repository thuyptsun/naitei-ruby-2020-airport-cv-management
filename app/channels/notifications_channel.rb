class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications:recruiters" if current_user.has_role? :recruiter
  end

  def unsubscribed
    stop_all_streams
  end
end
