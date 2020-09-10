class Recruiters::NotificationsController < ApplicationController
  layout "recruiters_application"
  before_action :authenticate_user!, :must_be_recruiter

  def index
    @q = Notification.ransack params[:q]
    @notifications = @q.result(distinct: true).desc_order.page(params[:page]).per Settings.notifications.per_page
  end

  private

  def must_be_recruiter
    return if current_user&.has_role? :recruiter

    flash[:error] = t ".you_are_not_allow_to_be_here"
    redirect_to root_path
  end
end
