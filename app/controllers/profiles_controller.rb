class ProfilesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied, with: :cancan_access_denied
  rescue_from ActiveRecord::RecordNotFound, with: :active_record_record_not_found

  def show; end

  def edit
    @new_education = Education.new profile_id: @profile.id
    @new_experience = Experience.new profile_id: @profile.id
  end

  def update
    if @profile.update profile_params
      @profile.file.attach(params[:profile][:file])
      Profile.all.with_attached_file
      flash[:success] = t ".profile_updated"
    else
      flash[:error] = t ".profile_update_failed"
    end

    respond_to do |format|
      format.html{render :edit}
      format.js
    end
  end

  private

  def profile_params
    params[:profile][:gender] = params[:profile][:gender].to_i
    params.require(:profile).permit Profile::PROFILE_PARAMS
  end

  def cancan_access_denied
    flash[:error] = t "shared.error_messages.you_are_not_allow_to_do_this_action"
    redirect_to root_url
  end

  def active_record_record_not_found
    flash[:warning] = t "shared.error_messages.profile_not_found"
    redirect_to root_path
  end
end
