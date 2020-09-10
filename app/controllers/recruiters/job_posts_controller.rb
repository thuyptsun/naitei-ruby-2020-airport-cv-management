class Recruiters::JobPostsController < ApplicationController
  layout "recruiters_application"
  before_action :must_be_a_recruiter
  load_and_authorize_resource param_method: :job_post_params
  skip_load_and_authorize_resource only: :index
  rescue_from CanCan::AccessDenied, with: :cancan_access_denied
  rescue_from ActiveRecord::RecordNotFound, with: :active_record_record_not_found

  def index
    @q = JobPost.ransack params[:q]
    @job_posts = @q.result(distinct: true).desc_order.page(params[:page]).per Settings.job_posts.per_page
  end

  def new; end

  def show; end

  def edit
    @job_post = JobPost.find_by id: params[:id]
  end

  def create
    @job_post.user = current_user
    if @job_post.save
      flash[:success] = t ".success"
      redirect_to recruiters_job_post_path @job_post
    else
      flash.now[:error] = t ".error"
      render :new
    end
  end

  def update
    if @job_post.update job_post_params
      flash[:success] = t ".success"
      redirect_to recruiters_job_post_path @job_post
    else
      flash[:danger] = t ".error"
      render :edit
    end
  end

  def destroy
    @job_post = JobPost.find_by id: params[:id]
    if @job_post.destroy
      flash[:success] = t ".success"
      redirect_to recruiters_job_posts_path
    else
      flash[:danger] = t ".error"
    end
  end

  private

  def job_post_params
    params.require(:job_post).permit JobPost::JOBPOST_PARAMS
  end

  def cancan_access_denied
    flash[:error] = t "shared.error_messages.you_are_not_allow_to_do_this_action"
    redirect_to root_url
  end

  def active_record_record_not_found
    flash[:warning] = t "shared.error_messages.job_post_not_found"
    redirect_to root_path
  end

  def must_be_a_recruiter
    return if current_user&.has_role? :recruiter

    flash[:error] = t "shared.error_messages.you_are_not_allow_to_do_this_action"
    redirect_to root_path
  end
end
