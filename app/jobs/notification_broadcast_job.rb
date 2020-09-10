class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform notification
    ActionCable.server.broadcast "notifications:recruiters",
                                 counter: Notification.all.size,
                                 layout: render_notification(notification)
  end

  private

  def render_counter counter
    ApplicationController.renderer.render(partial: "recruiters/notifications/counter", locals: {counter: counter})
  end

  def render_notification notification
    ApplicationController.renderer.render partial: "recruiters/notifications/notification",
                                          locals: {notification: notification}
  end
end
